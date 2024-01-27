//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//




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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @StateObject private var locationManager = CoreLocationViewModel()
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen()
                    .environmentObject(weatherViewModel)
                    .environmentObject(persistenceLocations)
                    .environmentObject(locationManager)
                    .environmentObject(appStateManager)



            }
            .navigationViewStyle(.stack)
        }
    }
}
