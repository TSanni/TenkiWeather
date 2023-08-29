//
//  AppStateManager.swift
//  Weather
//
//  Created by Tomas Sanni on 7/1/23.
//

import Foundation

class AppStateManager: ObservableObject {
    @Published var showSearchScreen: Bool = false
    @Published var showSettingScreen: Bool = false
    @Published var resetScrollToggle: Bool = false
    @Published var loading: Bool = false
    @Published var weatherTab: WeatherTabs = .today
    
    @Published var currentLocationName: String = ""
    @Published var currentLocationTimezone: Int = 0

    
    @Published var searchedLocationDictionary: [String: Any] = [
        "name": "",
        "latitude": 0,
        "longitude": 0,
        "timezone": 0.0,
        "temperature": "",
        "date": "",
        "symbol": ""
    ]
    
    
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
    
    
    func setSearchedLocationDictionary(name: String, latitude: Double, longitude: Double, timezone: Int, temperature: String, date: String, symbol: String) {
        
        searchedLocationDictionary["name"] = name
        searchedLocationDictionary["latitude"] = latitude
        searchedLocationDictionary["longitude"] = longitude
        searchedLocationDictionary["timezone"] = timezone
        searchedLocationDictionary["temperature"] = temperature
        searchedLocationDictionary["date"] = date
        searchedLocationDictionary["symbol"] = symbol
    }
    
    func dataIsLoading() {
        self.loading = true
    }
    
    func dataCompletedLoading() {
        self.loading = false
    }
    
}
