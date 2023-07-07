//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation



// Main screens get environment objects. Lesser views get passed in data

struct MainScreen: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @StateObject private var locationManager = CoreLocationViewModel()
    @StateObject private var appStateManager = AppStateManager()
    
    @State private var savedDate = Date()
    @State private var weatherTab: WeatherTabs = .today
    @State private var redraw: Bool = true
    
    //@State can survive reloads on the `View`
    @State private var taskId: UUID = .init()
    @Namespace var namespace
    
    
    func getBarColor() -> Color {
        switch weatherTab {
            case .today:
                return weatherViewModel.currentWeather.backgroundColor
            case .tomorrow:
                return weatherViewModel.tomorrowWeather.backgroundColor
            case .multiDay:
                return Color(uiColor: K.Colors.tenDayBarColor)
        }
    }
    
    var blurBackGround: some View {
        Group {
            if appStateManager.showSettingScreen {
//                Color.clear.background(.ultraThinMaterial)
                Color.black.ignoresSafeArea().opacity(0.5)
                    .onTapGesture { appStateManager.showSettingScreen = false }
            }
        }
    }
    
    var body: some View {
        
        Group {
            if appStateManager.showSearchScreen {
                VStack {
                    SearchingScreen()
                        .environmentObject(weatherViewModel)
                        .environmentObject(appStateManager)
                        .environmentObject(locationManager)
                        .environmentObject(persistenceLocations)
                    
                }
            } else {
                
                ZStack {
                    VStack(spacing: 0) {
                        
                        SearchBar()
                            .environmentObject(weatherViewModel)
                            .environmentObject(locationManager)
                            .environmentObject(appStateManager)
                            .onTapGesture {
                                appStateManager.showSearchScreen = true
                            }
                            .padding()
                        
                        WeatherTabSelectionsView(weatherTab: $weatherTab, namespace: namespace)
                        TabView(selection: $weatherTab) {
                            Group {
                                
                                TodayScreen(currentWeather: weatherViewModel.currentWeather)
                                    .tag(WeatherTabs.today)
                                    .environmentObject(weatherViewModel)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
                                
                                TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                                    .tag(WeatherTabs.tomorrow)
                                    .environmentObject(weatherViewModel)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
                                
                                MultiDayScreen(daily: weatherViewModel.dailyWeather)
                                    .tag(WeatherTabs.multiDay)
                                    .environmentObject(weatherViewModel)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
                            }
                            .onAppear {
                                /// Need this onAppear method to remedy a bug where the tab selection does not change tab
                                let holderTab = weatherTab
                                weatherTab = .today
                                weatherTab = holderTab
                            }
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                    }
                    .background(getBarColor().brightness(-0.1).ignoresSafeArea())
//                    .brightness(appStateManager.showSettingScreen ? -0.2 : 0)
                    .zIndex(0)
                    .disabled(appStateManager.showSettingScreen ? true : false)
                    .onTapGesture {
                        appStateManager.showSettingScreen = false
                    }
                    
                    
                    
                    blurBackGround
                    
                    
                    if appStateManager.showSettingScreen {
                        SettingsScreen()
//                            .transition(.scale)
                            .environmentObject(appStateManager)
                            .environmentObject(persistenceLocations)
                            .frame(height: 300)
                            .padding()
                            .zIndex(1)
                    }
                }
            }
        }
        .animation(.default, value: weatherTab)
        .refreshable {
            print("refreshable")
            //Cause .task to re-run by changing the id.
            taskId = .init()
        }
        .task(id: taskId) {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                try? await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let timezone = locationManager.timezoneForCoordinateInput
                await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                let userLocationName = locationManager.currentLocationName
                await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)


                appStateManager.searchedLocationDictionary["name"] = userLocationName
                appStateManager.searchedLocationDictionary["latitude"] = locationManager.latitude
                appStateManager.searchedLocationDictionary["longitude"] = locationManager.longitude
                appStateManager.searchedLocationDictionary["timezone"] = timezone

                appStateManager.searchedLocationDictionary["temperature"] = weatherViewModel.currentWeather.currentTemperature

                appStateManager.searchedLocationDictionary["date"] = weatherViewModel.currentWeather.date

                appStateManager.searchedLocationDictionary["symbol"] = weatherViewModel.currentWeather.symbol

                persistenceLocations.saveData()
                
            }
        }
        .onChange(of: locationManager.authorizationStatus) { newValue in
            if newValue == .authorizedWhenInUse {
                Task {
                    try await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    let timezone = locationManager.timezoneForCoordinateInput
                    await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                    let userLocationName = locationManager.currentLocationName
                    await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)

                    appStateManager.searchedLocationDictionary["name"] = userLocationName
                    appStateManager.searchedLocationDictionary["latitude"] = locationManager.latitude
                    appStateManager.searchedLocationDictionary["longitude"] = locationManager.longitude
                    appStateManager.searchedLocationDictionary["timezone"] = timezone

                    persistenceLocations.saveData()

                }
            }
        }
        .onChange(of: scenePhase) { newValue in
            //use this modifier to periodically update the information
            if newValue == .active {
                
                Task {
                    if -savedDate.timeIntervalSinceNow > 60 * 10 {
                        print("10 minutes have passed")
                        
                        try await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                        let timezone = locationManager.timezoneForCoordinateInput
                        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                        let userLocationName = locationManager.currentLocationName
                        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)

                        appStateManager.searchedLocationDictionary["name"] = userLocationName
                        appStateManager.searchedLocationDictionary["latitude"] = locationManager.latitude
                        appStateManager.searchedLocationDictionary["longitude"] = locationManager.longitude
                        appStateManager.searchedLocationDictionary["timezone"] = timezone

                        persistenceLocations.saveData()
                        
                        
                        
                        savedDate = Date()
                    } else {
                        print("10 minutes have NOT passed")
                    }
                }
                

            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(WeatherViewModel())
            .environmentObject(CoreLocationViewModel())
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())
        
        MainScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        MainScreen()
            .previewDevice("iPhone SE (3rd generation)")
    }
}
