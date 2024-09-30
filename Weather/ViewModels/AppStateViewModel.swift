//
//  AppStateViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation
import SwiftUI
import GooglePlaces



@MainActor class AppStateViewModel: ObservableObject {
    @Published private(set) var resetViews: Bool = false
    @Published private(set) var loading: Bool = false
    @Published private(set) var currentLocationName: String = ""
    @Published private(set) var currentLocationTimezone: Int = 0
    @Published private(set) var lastUpdated: String = ""
    @Published var showSearchScreen: Bool = false
    @Published var showSettingScreen: Bool = false
    // This property's only purpose is to add data to CoreData.
    // You can find it's data being saved to CoreData in the SettingScreenTile View
    // This is the only dictionary type in the project
    @Published private(set) var searchedLocationDictionary: SearchLocationModel =
        SearchLocationModel(
            name: "",
            latitude: 0,
            longitude: 0,
            timezone: 0,
            temperature: "",
            date: "",
            symbol: "",
            weatherCondition: "",
            weatherAlert: false
        )

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    
    static let shared  = AppStateViewModel()
    let weatherManager = WeatherManager.shared
    let locationViewModel = CoreLocationViewModel.shared
    let weatherViewModel = WeatherViewModel.shared
    let persistence = SavedLocationsPersistenceViewModel.shared
    
    private init() { }
    
    func toggleShowSearchScreen() {
        DispatchQueue.main.async {
            self.showSearchScreen.toggle()
        }
    }
    
    func toggleShowSettingScreen() {
        DispatchQueue.main.async {
            self.showSettingScreen.toggle()
        }
    }
    
    ///Returns columns and tile size accounting for iPhone and iPad
    func getGridColumnAndSize(geo: GeometryProxy) -> [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [GridItem(.adaptive(minimum: geo.size.width * 0.20, maximum: .infinity))]
            
        } else {
            return [GridItem(.adaptive(minimum: geo.size.width * 0.44, maximum: 200))]
        }
    }
    
    func performViewReset() {
        resetViews.toggle()
    }
    
    func setCurrentLocationName(name: String) {
        currentLocationName = name
    }
    
    func setCurrentLocationTimezone(timezone: Int) {
        currentLocationTimezone = timezone
    }
    
    private func setSearchedLocationDictionary(name: String, latitude: Double, longitude: Double, timezone: Int, temperature: String, date: String, symbol: String, weatherCondition: String, weatherAlert: Bool) {
        
        self.searchedLocationDictionary = SearchLocationModel(
            name: name,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone,
            temperature: temperature,
            date: date,
            symbol: symbol,
            weatherCondition: weatherCondition,
            weatherAlert: weatherAlert
        )
    }

    func dataIsLoading() {
        self.loading = true
    }
    
    func dataCompletedLoading() {
        self.loading = false
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
    
    func getWeatherAndUpdateDictionaryFromSavedLocation(item: Location) async {
        print(#function)
        toggleShowSearchScreen()
        dataIsLoading()
        await locationViewModel.getLocalLocationName()
        await locationViewModel.getSearchedLocationName(lat: item.latitude, lon: item.longitude, nameFromGoogle: nil)
        await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationViewModel.timezoneForCoordinateInput)
        await weatherViewModel.getLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: locationViewModel.localLocationName, timezone: currentLocationTimezone)
        
        locationViewModel.searchedLocationName = item.name!
        
        setSearchedLocationDictionary(
            name: locationViewModel.searchedLocationName,
            latitude: item.latitude,
            longitude: item.longitude,
            timezone: Int(item.timezone),
            temperature: item.temperature ?? "",
            date: item.currentDate ?? "",
            symbol: item.sfSymbol ?? "sun.max.fill",
            weatherCondition: item.weatherCondition ?? "",
            weatherAlert: item.weatherAlert
        )

        dataCompletedLoading()
        setLastUpdated()
        performViewReset()
    }
    
    func getWeatherAndUpdateDictionaryFromLocation() async {
        print(#function)
        toggleShowSearchScreen()
        dataIsLoading()
        await locationViewModel.getLocalLocationName()
        let timezone = locationViewModel.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, timezone: timezone)
        let userLocationName = locationViewModel.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: userLocationName, timezone: timezone)
        locationViewModel.searchedLocationName = userLocationName
        let currentWeather = weatherViewModel.currentWeather

        setCurrentLocationName(name: userLocationName)
        
        setSearchedLocationDictionary(
            name: locationViewModel.searchedLocationName,
            latitude: locationViewModel.latitude,
            longitude: locationViewModel.longitude,
            timezone: timezone,
            temperature: currentWeather.temperature.value.description,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            weatherAlert: weatherViewModel.weatherAlert != nil ? true : false
        )
        
        dataCompletedLoading()
        setLastUpdated()
        performViewReset()
    }
    
    func getWeatherWithGoogleData(place: GMSPlace) async {
        print(#function)
        dataIsLoading()
        let coordinates = place.coordinate
        await locationViewModel.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, nameFromGoogle: place.name)
        let timezone = locationViewModel.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
        let currentWeather = weatherViewModel.currentWeather
        setSearchedLocationDictionary(
            name: locationViewModel.searchedLocationName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: timezone,
            temperature: currentWeather.temperature.value.description,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            weatherAlert: weatherViewModel.weatherAlert != nil ? true : false
        )
        
        dataCompletedLoading()
        toggleShowSearchScreen()
        setLastUpdated()
        performViewReset()
    }
    
    func getWeather() async {
        print(#function)
        dataIsLoading()
        
        await locationViewModel.getLocalLocationName()
        locationViewModel.searchedLocationName = locationViewModel.localLocationName
        let timezone = locationViewModel.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, timezone: timezone)
        let userLocationName = locationViewModel.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationViewModel.latitude, longitude: locationViewModel.longitude, name: userLocationName, timezone: timezone)
        
        setCurrentLocationName(name: userLocationName)
        setCurrentLocationTimezone(timezone: timezone)
        dataCompletedLoading()
        
        setSearchedLocationDictionary(
            name: userLocationName,
            latitude: locationViewModel.latitude,
            longitude: locationViewModel.longitude,
            timezone: timezone,
            temperature: weatherViewModel.currentWeather.temperature.value.description,
            date: weatherViewModel.currentWeather.readableDate,
            symbol: weatherViewModel.currentWeather.symbolName,
            weatherCondition: weatherViewModel.currentWeather.weatherDescription,
            weatherAlert: weatherViewModel.weatherAlert != nil ? true : false
        )
        
        setLastUpdated()
                
        performViewReset()

        persistence.saveData()
    }
    
    private func setLastUpdated() {
        lastUpdated = Helper.getReadableMainDate(date: Date.now, timezoneOffset: TimeZone.current.secondsFromGMT())

    }
    
}
