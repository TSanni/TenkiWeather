//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//



//TODO: Add rain and snow effect 



import SwiftUI
import UIKit
import GooglePlaces

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSPlacesClient.provideAPIKey(K.googleApiKey)
        return true
    }
}

@main
struct WeatherApp: App {
    @State private var savedDate = Date()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    @StateObject private var weatherViewModel = WeatherViewModel.shared
    @StateObject private var persistenceLocations = SavedLocationsPersistence.shared
    @StateObject private var locationManager = CoreLocationViewModel.shared
    @StateObject private var appStateManager = AppStateManager.shared
    @StateObject private var networkManager = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen()
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistenceLocations)
                    .environmentObject(locationManager)
                    .environmentObject(appStateManager)
                    .environmentObject(networkManager)
            }
            .navigationViewStyle(.stack)
            .task {
                  if locationManager.authorizationStatus == .authorizedWhenInUse {
                      await appStateManager.getWeather()
                  }
              }
              .onChange(of: locationManager.authorizationStatus) { newValue in
                  if newValue == .authorizedWhenInUse {
                      Task {
                          await appStateManager.getWeather()
                      }
                  }
              }
              .onChange(of: scenePhase) { newValue in
                  //use this modifier to periodically update the weather data
                  if newValue == .active {
                      Task {
                          if -savedDate.timeIntervalSinceNow > 60 * 10 {
                              // 10 minutes have passed, refresh the data
                              await appStateManager.getWeather()
                              savedDate = Date()
                          } else {
                              // 10 minutes have NOT passed, do nothing
                              return
                          }
                      }
                  }
              }
        }
    }
}
