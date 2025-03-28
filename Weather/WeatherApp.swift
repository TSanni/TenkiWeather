//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//

//MARK: Version 4.11.1 published to App Store

//TODO: Fix .renderingMode in files. This is the cause of the CoreSVG: Error: NULL ref passed to getObjectCoreSVG
//TODO: Remove Google APIs from project

import SwiftUI
import UIKit
import BackgroundTasks

// no changes in your AppDelegate class


@main
struct WeatherApp: App {
    @State private var savedDate = Date()

    @Environment(\.scenePhase) var scenePhase

    @StateObject private var weatherViewModel = WeatherViewModel.shared
    @StateObject private var persistenceLocations = SavedLocationsPersistenceViewModel.shared
    @StateObject private var locationViewModel = CoreLocationViewModel.shared
    @StateObject private var appStateViewModel = AppStateViewModel.shared
    @StateObject private var networkManager = NetworkMonitor()
    @StateObject private var locationSearchViewModel = LocationSearchViewModel()
    
    init() {
        UserDefaults.standard.set("timeAdded", forKey: "sortType")
        UserDefaults.standard.set(false, forKey: "ascending")
    }
    
    let backgroundClass = BackgroundTasksManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainScreen()
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistenceLocations)
                    .environmentObject(locationViewModel)
                    .environmentObject(appStateViewModel)
                    .environmentObject(networkManager)
                    .environmentObject(locationViewModel)
                    .environmentObject(locationSearchViewModel)
            }
            .task {
                  if locationViewModel.authorizationStatus == .authorizedWhenInUse {
                      await appStateViewModel.getWeather()
                  }
              }
            .onChange(of: locationViewModel.authorizationStatus, { oldValue, newValue in
                switch newValue {
                case .authorizedWhenInUse:
                    Task {
                        await appStateViewModel.getWeather()
                    }
                default: break
                }
            })
              .onChange(of: scenePhase) { oldValue, newValue in
                  //use this modifier to periodically update the weather data
                  switch newValue {
                  case .active:
                      Task {
                          if -savedDate.timeIntervalSinceNow > 60 * 10 {
                              // 10 minutes have passed, refresh the data
                              await appStateViewModel.getWeather()
                              await persistenceLocations.callFetchWeatherPlacesWithTaskGroup()
                              savedDate = Date()
                          } else {
                              // 10 minutes have NOT passed, do nothing
                              return
                          }
                      }
                      
                  case .background: backgroundClass.startBackgroundTasks()
                  default: break
                  }
              }
        }
        .backgroundTask(.appRefresh("getCurrentWeather")) { _ in
            await appStateViewModel.getWeather()
            await backgroundClass.startBackgroundTasks()
        }
    }
}
