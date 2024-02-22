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
            .task {
                  if locationManager.authorizationStatus == .authorizedWhenInUse {
                      await getWeather()
                  }
              }
              .onChange(of: locationManager.authorizationStatus) { newValue in
                  if newValue == .authorizedWhenInUse {
                      Task {
                          await getWeather()
                      }
                  }
              }
              .onChange(of: scenePhase) { newValue in
                  //use this modifier to periodically update the weather data
                  if newValue == .active {
                      Task {
                          if -savedDate.timeIntervalSinceNow > 60 * 10 {
                              // 10 minutes have passed, refresh the data
                              await getWeather()
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
    
    
    
    private func getWeather() async {
        appStateManager.dataIsLoading()
        
        await locationManager.getLocalLocationName()
        locationManager.searchedLocationName = locationManager.localLocationName
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        
        appStateManager.setCurrentLocationName(name: userLocationName)
        appStateManager.setCurrentLocationTimezone(timezone: timezone)
        appStateManager.dataCompletedLoading()
        
        appStateManager.setSearchedLocationDictionary(
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
        
        appStateManager.performViewReset()
        
        
        persistenceLocations.saveData()
    }

}
