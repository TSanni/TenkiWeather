//
//  AppStateManager.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation
import SwiftUI
import GooglePlaces

@MainActor class AppStateManager: ObservableObject {
    @Published var showSearchScreen: Bool = false
    @Published var showSettingScreen: Bool = false
    @Published var resetViews: Bool = false
    @Published var loading: Bool = false
    
    @Published var currentLocationName: String = ""
    @Published var currentLocationTimezone: Int = 0
    
    // This property's only purpose is to add data to CoreData.
    // You can find it's data being saved to CoreData in the SettingScreenTile View
    // This is the only dictionary type in the project
    @Published var searchedLocationDictionary: [String: Any] = [
        K.LocationDictionaryKeysConstants.name: "",
        K.LocationDictionaryKeysConstants.latitude: 0,
        K.LocationDictionaryKeysConstants.longitude: 0,
        K.LocationDictionaryKeysConstants.timezone: 0.0,
        K.LocationDictionaryKeysConstants.temperature: "",
        K.LocationDictionaryKeysConstants.date: "",
        K.LocationDictionaryKeysConstants.symbol: "",
        K.LocationDictionaryKeysConstants.weatherCondition: ""
    ]
    
    static let shared  = AppStateManager()
    let weatherManager = WeatherManager.shared
    let locationManager = CoreLocationViewModel.shared
    let weatherViewModel = WeatherViewModel.shared
    let persistence = SavedLocationsPersistence.shared

    
    private init() { }
    
    func toggleShowSearchScreen() {
        DispatchQueue.main.async {
            self.showSearchScreen.toggle()
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
    
    
    func setSearchedLocationDictionary(name: String, latitude: Double, longitude: Double, timezone: Int, temperature: String, date: String, symbol: String, weatherCondition: String, unitTemperature: UnitTemperature) {
        
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.name] = name
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.latitude] = latitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.longitude] = longitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.timezone] = timezone
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.temperature] = temperature
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.date] = date
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.symbol] = symbol
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.weatherCondition] = weatherCondition
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.unitTemperature] = unitTemperature
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
    
    
    func blendColors(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.7, color2: themeColor, intensity2: 0.3))
        
        return blendedColor
    }
    
    func blendColors2(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.6, color2: themeColor, intensity2: 0.4))
        
        return blendedColor
    }
    
    func blendColorWithTwentyPercentWhite(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.2, color2: themeColor, intensity2: 0.8))
        
        return blendedColor
    }
    
    func blendColorWithTwentyPercentBlack(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .black, intensity1: 0.2, color2: themeColor, intensity2: 0.8))
        
        return blendedColor
    }
    
    func fillImageToPrepareForRendering(symbol: String) -> String {
        let filledInSymbol = weatherManager.getImage(imageName: symbol)
        return filledInSymbol
    }
    
    func getWeatherAndUpdateDictionaryFromSavedLocation(item: LocationEntity) async {
        toggleShowSearchScreen()
        dataIsLoading()
        await locationManager.getLocalLocationName()
        await locationManager.getSearchedLocationName(lat: item.latitude, lon: item.longitude, nameFromGoogle: nil)
        await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: locationManager.localLocationName, timezone: currentLocationTimezone)
        
        locationManager.searchedLocationName = item.name!

        searchedLocationDictionary[K.LocationDictionaryKeysConstants.name] = locationManager.searchedLocationName
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.longitude] = item.longitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.latitude] = item.latitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.timezone] = item.timezone
        
        dataCompletedLoading()
        performViewReset()
    }
    
    func getWeatherAndUpdateDictionaryFromLocation() async {
        toggleShowSearchScreen()
        dataIsLoading()
        await locationManager.getLocalLocationName()
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        locationManager.searchedLocationName = userLocationName
        
        setCurrentLocationName(name: userLocationName)
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.name] = locationManager.searchedLocationName
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.latitude] = locationManager.latitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.longitude] = locationManager.longitude
        searchedLocationDictionary[K.LocationDictionaryKeysConstants.timezone] = timezone
        
        
        dataCompletedLoading()
        performViewReset()
    }
    
    func getWeatherWithGoogleData(place: GMSPlace, currentWeather: TodayWeatherModel) async {
        
        dataIsLoading()
        let coordinates = place.coordinate
        await locationManager.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, nameFromGoogle: place.name)
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
        
        setSearchedLocationDictionary(
            name: locationManager.searchedLocationName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: timezone,
            temperature: currentWeather.currentTemperature,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            unitTemperature: Helper.getUnitTemperature()
        )
        
        dataCompletedLoading()
        toggleShowSearchScreen()
        performViewReset()
    }
    
    func getWeather() async {
        dataIsLoading()
        
        await locationManager.getLocalLocationName()
        locationManager.searchedLocationName = locationManager.localLocationName
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        
        setCurrentLocationName(name: userLocationName)
        setCurrentLocationTimezone(timezone: timezone)
        dataCompletedLoading()
        
        setSearchedLocationDictionary(
            name: userLocationName,
            latitude: locationManager.latitude,
            longitude: locationManager.longitude,
            timezone: timezone,
            temperature: weatherViewModel.currentWeather.currentTemperature,
            date: weatherViewModel.currentWeather.readableDate,
            symbol: weatherViewModel.currentWeather.symbolName,
            weatherCondition: weatherViewModel.currentWeather.weatherDescription,
            unitTemperature: Helper.getUnitTemperature()
        )
        
        performViewReset()

        persistence.saveData()
    }
    
}
