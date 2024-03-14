//
//  AppStateViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation
import SwiftUI
import GooglePlaces

//TODO: Add gesture ability for underline when swiping to new tab 

@MainActor class AppStateViewModel: ObservableObject {
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
    
    @Published var startingOffsetX: CGFloat = 0
    @Published var currentDragOffsetX: CGFloat = 0
    @Published var endingOffsetX: CGFloat = 0
    
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
        let filledInSymbol = weatherViewModel.getImage(imageName: symbol)
        return filledInSymbol
    }
    
    func getWeatherAndUpdateDictionaryFromSavedLocation(item: Location) async {
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
            symbol: item.sfSymbol ?? "",
            weatherCondition: item.weatherCondition ?? "",
            unitTemperature: item.unitTemperature ?? .fahrenheit
        )

        dataCompletedLoading()
        performViewReset()
    }
    
    func getWeatherAndUpdateDictionaryFromLocation() async {
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
            temperature: currentWeather.currentTemperature,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            unitTemperature: Helper.getUnitTemperature()
        )
        
        dataCompletedLoading()
        performViewReset()
    }
    
    func getWeatherWithGoogleData(place: GMSPlace) async {
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
