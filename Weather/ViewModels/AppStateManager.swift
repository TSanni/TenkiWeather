//
//  AppStateManager.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation
import SwiftUI

class AppStateManager: ObservableObject {
    @Published var showSearchScreen: Bool = false
    @Published var showSettingScreen: Bool = false
    @Published var resetScrollToggle: Bool = false
    @Published var loading: Bool = false
    @Published var weatherTab: WeatherTabs = .today
    
    @Published var currentLocationName: String = ""
    @Published var currentLocationTimezone: Int = 0

    
    // This property's only purpose is to add data to CoreData.
    // You can find it's data being saved to CoreData in the SettingScreenTile View
    // This is the only dictionary type in the project
    @Published var searchedLocationDictionary: [String: Any] = [
        K.LocationDictionaryKeys.name: "",
        K.LocationDictionaryKeys.latitude: 0,
        K.LocationDictionaryKeys.longitude: 0,
        K.LocationDictionaryKeys.timezone: 0.0,
        K.LocationDictionaryKeys.temperature: "",
        K.LocationDictionaryKeys.date: "",
        K.LocationDictionaryKeys.symbol: "",
        K.LocationDictionaryKeys.weatherCondition: ""
    ]
    
    func changeWeatherTab(tab: WeatherTabs) {
        withAnimation {
            weatherTab = tab
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
    
    func scrollToTopAndChangeTabToToday() {
        resetScrollToggle.toggle()
        weatherTab = .today
    }
    
    func setCurrentLocationName(name: String) {
        currentLocationName = name
    }
    
    func setCurrentLocationTimezone(timezone: Int) {
        currentLocationTimezone = timezone
    }
    
    
    func setSearchedLocationDictionary(name: String, latitude: Double, longitude: Double, timezone: Int, temperature: String, date: String, symbol: String, weatherCondition: String) {
        
        searchedLocationDictionary[K.LocationDictionaryKeys.name] = name
        searchedLocationDictionary[K.LocationDictionaryKeys.latitude] = latitude
        searchedLocationDictionary[K.LocationDictionaryKeys.longitude] = longitude
        searchedLocationDictionary[K.LocationDictionaryKeys.timezone] = timezone
        searchedLocationDictionary[K.LocationDictionaryKeys.temperature] = temperature
        searchedLocationDictionary[K.LocationDictionaryKeys.date] = date
        searchedLocationDictionary[K.LocationDictionaryKeys.symbol] = symbol
        searchedLocationDictionary[K.LocationDictionaryKeys.weatherCondition] = weatherCondition
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
        let filledInSymbol = WeatherManager.shared.getImage(imageName: symbol)
        return filledInSymbol
    }
    
}
