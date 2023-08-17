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
    
    //@State can survive reloads on the `View`
    @State private var taskId: UUID = .init()
    
    func getWeather() async {
        await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                
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
    
    
    
    var getBarColor: Color {
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
                Color.black.ignoresSafeArea().opacity(0.5)
                    .onTapGesture { appStateManager.showSettingScreen = false }
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                SearchBar()
                    .environmentObject(weatherViewModel)
                    .environmentObject(locationManager)
                    .environmentObject(appStateManager)
                    .onTapGesture {
                        appStateManager.showSearchScreen = true
                    }
                
                WeatherTabSelectionsView(weatherTab: $weatherTab)
                
                TabView(selection: $weatherTab) {
                    
                    
                    TodayScreen(currentWeather: weatherViewModel.currentWeather)
                        .tabItem {
                            Label("Today", systemImage: "sun.min")
                        }
                        .tag(WeatherTabs.today)
                        .environmentObject(weatherViewModel)
                        .environmentObject(appStateManager)

                    
                    
                    TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                        .tabItem {
                            Label("Tomorrow", systemImage: "snow")
                        }
                        .tag(WeatherTabs.tomorrow)
                        .environmentObject(weatherViewModel)
                    
                    MultiDayScreen(daily: weatherViewModel.dailyWeather)
                        .tabItem {
                            Label("10 Days", systemImage: "cloud")
                        }
                        .tag(WeatherTabs.multiDay)
                        .environmentObject(weatherViewModel)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.bottom)
                
            }
            .background(getBarColor.brightness(-0.1).ignoresSafeArea())
            .zIndex(0)
            .disabled(appStateManager.showSettingScreen ? true : false)

            
            
            
            blurBackGround
            
            
            if appStateManager.showSettingScreen {
                SettingsScreen()
                    .environmentObject(appStateManager)
                    .environmentObject(persistenceLocations)
                    .settingsFrame()
                    .padding()
                    .zIndex(1)
            }
        }
        .animation(.default, value: weatherTab)
        .fullScreenCover(isPresented: $appStateManager.showSearchScreen) {
            SearchingScreen()
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .environmentObject(locationManager)
                .environmentObject(persistenceLocations)
        }
        .alert("Weather Request Failed", isPresented: $weatherViewModel.errorPublisher.errorBool) {
            
        } message: {
            Text(weatherViewModel.errorPublisher.errorMessage)
        }
        .refreshable {
            print("refreshable")
            //Cause .task to re-run by changing the id.
            //            taskId = .init()
            await getWeather()
        }
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
            //use this modifier to periodically update the information
            if newValue == .active {
                Task {
                    if -savedDate.timeIntervalSinceNow > 60 * 10 {
                        print("10 minutes have passed")
                        await getWeather()
                        weatherTab = .today
                        appStateManager.resetScrollViewToTop()
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
        
//        MainScreen()
//            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
//        MainScreen()
//            .previewDevice("iPhone SE (3rd generation)")
    }
}
