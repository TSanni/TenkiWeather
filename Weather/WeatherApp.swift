//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//

//MARK: Version 4.15.0 published to App Store

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
    
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        let weatherManager = ProductionWeatherService()
        let weatherVM = WeatherViewModel(weatherService: weatherManager)
        let locationVM = CoreLocationViewModel()
        let persistenceVM = SavedLocationsPersistenceViewModel(weatherManager: weatherManager, coreLocationModel: locationVM)
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
                    .onChange(of: locationVM.authorizationStatus) { oldValue, newValue in
                        switch newValue {
                        case .authorizedWhenInUse:
                            if oldValue != newValue && oldValue != nil {
                                Task { await appStateVM.determineWeatherUpdateMethod() }
                            }
                        default: break
                        }
                    }
                    .onChange(of: scenePhase) { oldValue, newValue in
                        //use this modifier to periodically update the weather data
                        switch newValue {
                        case .active:
                            Task { await appStateVM.handleForegroundEntry() }
                        default:
                            break
                        }
                    }
                    .onChange(of: networkMonitor.isConnected) { oldValue, newValue in
                        if oldValue == false && newValue == true {
                            Task { await appStateVM.handleForegroundEntry() }
                        }
                    }
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
