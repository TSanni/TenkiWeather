//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//

//MARK: Version 4.11.1 published to App Store

//TODO: Fix .renderingMode in files. This is the cause of the CoreSVG: Error: NULL ref passed to getObjectCoreSVG

import SwiftUI

@main
struct WeatherApp: App {
    
    @StateObject private var weatherVM: WeatherViewModel
    @StateObject private var locationVM: CoreLocationViewModel
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var persistenceVM: SavedLocationsPersistenceViewModel
    @StateObject private var searchVM = LocationSearchViewModel()
    @StateObject private var appStateVM: AppStateViewModel
    
    init() {
        UserDefaults.standard.set("timeAdded", forKey: "sortType")
        UserDefaults.standard.set(false, forKey: "ascending")
        
        let weatherManager = ProductionWeatherService()
        let weatherVM = WeatherViewModel(weatherManager: weatherManager)
        let locationVM = CoreLocationViewModel()
        let persistenceVM = SavedLocationsPersistenceViewModel(weatherManager: weatherManager)
        let appStateVM = AppStateViewModel(
            locationViewModel: locationVM,
            weatherViewModel: weatherVM,
            persistence: persistenceVM
        )
        
        _weatherVM = StateObject(wrappedValue: weatherVM)
        _locationVM = StateObject(wrappedValue: locationVM)
        _persistenceVM = StateObject(wrappedValue: persistenceVM)
        _appStateVM = StateObject(wrappedValue: appStateVM)
    }
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainScreen()
                    .environmentObject(weatherVM)
                    .environmentObject(locationVM)
                    .environmentObject(networkMonitor)
                    .environmentObject(persistenceVM)
                    .environmentObject(searchVM)
                    .environmentObject(appStateVM)
            }
        }
    }
}
