//
//  AppStateViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation
import SwiftUI
import CoreLocation



@MainActor class AppStateViewModel: ObservableObject {
    @Published private(set) var resetViews: Bool = false
    @Published private(set) var loading: Bool = false
    @Published private(set) var currentLocationName: String = ""
    @Published private(set) var currentLocationTimezone: String
    
    @Published private(set) var lastUpdated: String = ""
    @Published private(set) var weatherError: WeatherErrors? = nil
    @Published private(set) var coreDataError: CoreDataErrors? = nil
    @Published var showCoreDataSuccessAlert = false
    @Published var showWeatherErrorAlert: Bool = false
    @Published var showCoreDataErrorAlert: Bool = false
    @Published var showSearchScreen: Bool = false
    @Published var showSettingScreen: Bool = false

    @Published var lastFetchTime: Date?
    
    // This property's only purpose is to add data to CoreData.
    // You can find it's data being saved to CoreData in the SettingScreenTile View
    @Published private(set) var searchedLocationModel: SearchLocationModel =
        SearchLocationModel(
            name: "",
            latitude: 0,
            longitude: 0,
            timeZoneIdentifier: K.defaultTimezoneIdentifier,
            temperature: "",
            date: "",
            symbol: "",
            weatherCondition: "",
            weatherAlert: false,
            timezone: 0
        )
    
    private var locationViewModel: CoreLocationViewModelProtocol
    private let weatherViewModel: WeatherViewModel
    private let persistence: SavedLocationsPersistenceViewModel
    
    private let lastFetchKey = "LastWeatherFetchTime"

    private var coldStart: Bool
    
    init(locationViewModel: CoreLocationViewModelProtocol, weatherViewModel: WeatherViewModel, persistence: SavedLocationsPersistenceViewModel) {
        self.locationViewModel = locationViewModel
        self.weatherViewModel = weatherViewModel
        self.persistence = persistence
        self.coldStart = true
        currentLocationTimezone = weatherViewModel.currentWeather.timezoneIdentifier
        
        // On cold launch, load last fetch time
        if let saved = UserDefaults.standard.object(forKey: lastFetchKey) as? Date {
            lastFetchTime = saved
        }

        // Always fetch on cold start
        Task {
            await determineWeatherUpdateMethod()
            self.coldStart = false
        }
        
    }
    
    private func setLastUpdated() {
        self.lastUpdated = Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: TimeZone.current.identifier)
    }
    
    func toggleShowSearchScreen() { self.showSearchScreen.toggle() }
    
    func toggleShowSettingScreen() { self.showSettingScreen.toggle() }
    
    private func performViewReset() { resetViews.toggle() }
    
    private func setCurrentLocationName(name: String) { currentLocationName = name }
    
    private func setCurrentLocationTimezone(timezone: String) { currentLocationTimezone = timezone }
    
    private func dataIsLoading() { self.loading = true }
    
    private func dataCompletedLoading() { self.loading = false }
    
    private func setSearchedLocationDictionary(name: String, latitude: Double, longitude: Double, timeZoneIdentifier: String, temperature: String, date: String, symbol: String, weatherCondition: String, weatherAlert: Bool, timezone: Int) {
        
        self.searchedLocationModel = SearchLocationModel(
            name: name,
            latitude: latitude,
            longitude: longitude,
            timeZoneIdentifier: timeZoneIdentifier,
            temperature: temperature,
            date: date,
            symbol: symbol,
            weatherCondition: weatherCondition,
            weatherAlert: weatherAlert,
            timezone: timezone
        )
    }
}

// MARK: - Handle Core Data
extension AppStateViewModel {
    func saveLocation() {
        do {
            try persistence.createLocation(locationInfo: searchedLocationModel)
            showCoreDataSuccessAlert.toggle()
        } catch let error as CoreDataErrors {
            coreDataError = error
            showCoreDataErrorAlert.toggle()
        } catch {
            print("Failed to save location. Error: \(error)")
        }
    }
}

// MARK: - Handle WeatherViewModel and LocationViewModel
extension AppStateViewModel {
    func getWeatherAndUpdateDictionaryFromSavedLocation(item: Location) async {
        print(#function)
        do {
            dataIsLoading()
            try await locationViewModel.getLocalLocationName()
            try await locationViewModel.getSearchedLocationName(lat: item.latitude, lon: item.longitude, name: nil)
            try await weatherViewModel.fetchWeather (latitude: item.latitude, longitude: item.longitude, timezoneIdentifier: locationViewModel.timezoneIdentifier)
            try await weatherViewModel.fetchLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: locationViewModel.localLocationName, timezoneIdentifier: currentLocationTimezone)
            
            locationViewModel.searchedLocationName = item.name!
            
            setSearchedLocationDictionary(
                name: locationViewModel.searchedLocationName,
                latitude: item.latitude,
                longitude: item.longitude,
                timeZoneIdentifier: item.timezoneIdentifier ?? K.defaultTimezoneIdentifier,
                temperature: item.temperature ?? "0",
                date: item.currentDate ?? Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: K.defaultTimezoneIdentifier),
                symbol: item.sfSymbol ?? "sun.max.fill",
                weatherCondition: item.weatherCondition ?? "cloudy",
                weatherAlert: item.weatherAlert,
                timezone: Int(item.timezone)
            )
            
            dataCompletedLoading()
            performViewReset()
            setLastUpdated()
        } catch let error as WeatherErrors {
            weatherError = error
            showWeatherErrorAlert.toggle()
        } catch {
            print("❌ Failed to getWeatherAndUpdateDictionaryFromSavedLocation")
        }
    }
    
    func getWeatherAndUpdateDictionaryFromLocation() async {
        print(#function)
        do {
            toggleShowSearchScreen()
            dataIsLoading()
            try await locationViewModel.getLocalLocationName()
            let timezoneIdentifier = locationViewModel.timezoneIdentifier
            let timezoneSecondsFromGMT = locationViewModel.timezoneSecondsFromGMT
            try await weatherViewModel.fetchWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, timezoneIdentifier: timezoneIdentifier)
            let userLocationName = locationViewModel.localLocationName
            try await weatherViewModel.fetchLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: userLocationName, timezoneIdentifier: timezoneIdentifier)
            locationViewModel.searchedLocationName = userLocationName
            let currentWeather = weatherViewModel.currentWeather

            setCurrentLocationName(name: userLocationName)
            
            setSearchedLocationDictionary(
                name: locationViewModel.searchedLocationName,
                latitude: locationViewModel.latitude,
                longitude: locationViewModel.longitude,
                timeZoneIdentifier: timezoneIdentifier,
                temperature: currentWeather.temperature.value.description,
                date: currentWeather.readableDate,
                symbol: currentWeather.symbolName,
                weatherCondition: currentWeather.weatherDescription.description,
                weatherAlert: weatherViewModel.weatherAlert != nil ? true : false,
                timezone: timezoneSecondsFromGMT
            )
            
            dataCompletedLoading()
            performViewReset()
            setLastUpdated()
        } catch let error as WeatherErrors {
            weatherError = error
            showWeatherErrorAlert.toggle()
        } catch {
            print("❌ Failed to getWeatherAndUpdateDictionaryFromLocation")
        }
    }
    
    func getWeatherFromLocationSearch(coordinate: CLLocationCoordinate2D, name: String) async {
        print(#function)
        do {
            dataIsLoading()
            let coordinates = coordinate
            try await locationViewModel.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, name: name)
            let timezoneIdentifier = locationViewModel.timezoneIdentifier
            let timezoneSecondsFromGMT = locationViewModel.timezoneSecondsFromGMT

            try await weatherViewModel.fetchWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezoneIdentifier: timezoneIdentifier)
            let currentWeather = weatherViewModel.currentWeather
            setSearchedLocationDictionary(
                name: name,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                timeZoneIdentifier: timezoneIdentifier,
                temperature: currentWeather.temperature.value.description,
                date: currentWeather.readableDate,
                symbol: currentWeather.symbolName,
                weatherCondition: currentWeather.weatherDescription.description,
                weatherAlert: weatherViewModel.weatherAlert != nil ? true : false,
                timezone: timezoneSecondsFromGMT
            )
            
            dataCompletedLoading()
            toggleShowSearchScreen()
            performViewReset()
            setLastUpdated()
        } catch let error as WeatherErrors {
            weatherError = error
            showWeatherErrorAlert.toggle()
        } catch {
            print("❌ Failed to getWeatherFromLocationSearch")
        }
    }
    
    func getWeather() async {
        print(#function)
        do {
            dataIsLoading()
            try await locationViewModel.getLocalLocationName()
            locationViewModel.searchedLocationName = locationViewModel.localLocationName
            let timezoneIdentifier = locationViewModel.timezoneIdentifier
            let timezoneSecondsFromGMT = locationViewModel.timezoneSecondsFromGMT
            try await weatherViewModel.fetchWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, timezoneIdentifier: timezoneIdentifier)
            let userLocationName = locationViewModel.localLocationName
            try await weatherViewModel.fetchLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: userLocationName, timezoneIdentifier: timezoneIdentifier)
            
            setCurrentLocationName(name: userLocationName)
            setCurrentLocationTimezone(timezone: timezoneIdentifier)
            dataCompletedLoading()
            
            setSearchedLocationDictionary(
                name: userLocationName,
                latitude: locationViewModel.latitude,
                longitude: locationViewModel.longitude,
                timeZoneIdentifier: timezoneIdentifier,
                temperature: weatherViewModel.currentWeather.temperature.value.description,
                date: weatherViewModel.currentWeather.readableDate,
                symbol: weatherViewModel.currentWeather.symbolName,
                weatherCondition: weatherViewModel.currentWeather.weatherDescription,
                weatherAlert: weatherViewModel.weatherAlert != nil ? true : false,
                timezone: timezoneSecondsFromGMT
            )
            performViewReset()
            setLastUpdated()
        } catch let error as WeatherErrors {
            weatherError = error
            showWeatherErrorAlert.toggle()
        } catch {
            print("❌ Failed to getWeather")
        }
    }
    
    /// This method determines if a user has marked a location as favorite.
    /// If true, the default weather updates will come from that location.
    /// Otherwise, weather will be updated based on user location.
    func determineWeatherUpdateMethod() async {
        print(#function)
        if let favoritedLocation = persistence.savedLocations.first(where: { $0.isFavorite }) {
            await getWeatherAndUpdateDictionaryFromSavedLocation(item: favoritedLocation)
        } else {
            await getWeather()
        }
        
        lastFetchTime = Date()
        UserDefaults.standard.set(lastFetchTime, forKey: lastFetchKey)
    }
    
    func handleForegroundEntry() async {
        print(#function)
        
        if self.coldStart {
            return
        }
        
        if let lastFetchTime = lastFetchTime {
            if -lastFetchTime.timeIntervalSinceNow > Double(K.TimeConstants.tenMinutesInSeconds) {
                print("10 minutes have passed since last fetch")
                await determineWeatherUpdateMethod()
            } else {
                print("⚠️ 10 minutes have NOT passed since last fetch")
            }
        } else {
            await determineWeatherUpdateMethod()
        }
    }
}

// MARK: - Handle UI
extension AppStateViewModel {
    ///Returns columns and tile size accounting for iPhone and iPad
    func getGridColumnAndSize(geo: GeometryProxy) -> [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [GridItem(.adaptive(minimum: geo.size.width * 0.20, maximum: .infinity))]
            
        } else {
            return [GridItem(.adaptive(minimum: geo.size.width * 0.44, maximum: 200))]
        }
    }
    
    func fortyFivePercentTileSize(geo: GeometryProxy) -> Double {
        return geo.size.width * 0.45
    }
    
    func mixColorWith70PercentWhite(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.7, color2: themeColor, intensity2: 0.3))
        
        return blendedColor
    }
    
    func mixColorWith60PercentWhite(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.6, color2: themeColor, intensity2: 0.4))
        
        return blendedColor
    }
    
    func blendColorWith20PercentWhite(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.2, color2: themeColor, intensity2: 0.8))
        
        return blendedColor
    }
    
    func blendColorWith20PercentBlack(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .black, intensity1: 0.2, color2: themeColor, intensity2: 0.8))
        
        return blendedColor
    }
    
    func fillImageToPrepareForRendering(symbol: String) -> String {
        let filledInSymbol = Helper.getImage(imageName: symbol)
        return filledInSymbol
    }
    
}
