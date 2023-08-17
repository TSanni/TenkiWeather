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
    
    @Published var searchedLocationDictionary: [String: Any] = [
        "name": "",
        "latitude": 0,
        "longitude": 0,
        "timezone": 0.0,
        "temperature": "",
        "date": "",
        "symbol": ""
        ]
    
    
    func resetScrollViewToTop() {
        resetScrollToggle.toggle()
    }
    
    
}
