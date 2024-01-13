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


//MARK: - View
struct MainScreen: View {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @StateObject private var locationManager = CoreLocationViewModel()
    @StateObject private var appStateManager = AppStateManager()
    @State private var savedDate = Date()
    

    
    var body: some View {
        ZStack {
            
            searchBarAndTabView
//                .font(.custom("Times New Roman", size: 20, relativeTo: .body))


    
            blurBackGround
            
            
            if appStateManager.showSettingScreen {
                settings
            }
            
            
            if appStateManager.loading {
                ProgressView()
            }
        }
        .redacted(reason: appStateManager.loading ? .placeholder : [])
        .animation(.default, value: appStateManager.weatherTab)
        .fullScreenCover(isPresented: $appStateManager.showSearchScreen) {
            SearchingScreen()
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .environmentObject(locationManager)
                .environmentObject(persistenceLocations)
        }
        .alert("Weather Request Failed", isPresented: $weatherViewModel.errorPublisher.errorBool) {
//            Button("Ok") {
//                NetworkMonitor.shared.startMonitoring()
//                
//                Task {
//                    await getWeather()
//                    NetworkMonitor.shared.stopMonitoring()
//                }
//                
//            }
        } message: {
            Text(weatherViewModel.errorPublisher.errorMessage)
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
                        savedDate = Date()
                    } else {
                        print("10 minutes have NOT passed")
                    }
                }
            }
        }
    }
}




//MARK: - Main View Extension
extension MainScreen {
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
            date: weatherViewModel.currentWeather.date,
            symbol: weatherViewModel.currentWeather.symbol
        )
        
        appStateManager.scrollToTopAndChangeTabToToday()
        
      
        persistenceLocations.saveData()
    }
    
    private var getBarColor: Color {
        switch appStateManager.weatherTab {
            case .today:
                return weatherViewModel.currentWeather.backgroundColor
            case .tomorrow:
                return weatherViewModel.tomorrowWeather.backgroundColor
            case .multiDay:
                return Color(uiColor: K.Colors.tenDayBarColor)
        }
    }
    
    private var blurBackGround: some View {
        Group {
            if appStateManager.showSettingScreen {
                Color.black.ignoresSafeArea().opacity(0.5)
                    .onTapGesture { appStateManager.showSettingScreen = false }
            }
        }
    }
    
    private var searchBarAndTabView: some View {
        VStack(spacing: 0) {
            
            SearchBar()
//                .font(.custom("Times New Roman", size: 20, relativeTo: .body))
                .environmentObject(weatherViewModel)
                .environmentObject(locationManager)
                .environmentObject(appStateManager)
                .onTapGesture {
                    appStateManager.showSearchScreen = true
                }
            
            WeatherTabSelectionsView(weatherTab: $appStateManager.weatherTab)

            
            TabView(selection: $appStateManager.weatherTab) {
                
                
                TodayScreen(currentWeather: weatherViewModel.currentWeather, weatherAlert: weatherViewModel.weatherAlert)
                    .tabItem {
                        Label("Today", systemImage: "sun.min")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(WeatherTabs.today)
                    .environmentObject(weatherViewModel)
                    .environmentObject(appStateManager)
                
                
                TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                    .tabItem {
                        Label("Tomorrow", systemImage: "snow")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(WeatherTabs.tomorrow)
                    .environmentObject(weatherViewModel)
                    .environmentObject(appStateManager)

                
                MultiDayScreen(daily: weatherViewModel.dailyWeather)
                    .tabItem {
                        Label("10 Days", systemImage: "cloud")
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .tag(WeatherTabs.multiDay)
                    .environmentObject(weatherViewModel)
                    .environmentObject(appStateManager)

            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.bottom)
            
        }
        .background(getBarColor.brightness(-0.1).ignoresSafeArea())
        .zIndex(0)
        .disabled(appStateManager.showSettingScreen ? true : false)
    }
    
    private var settings: some View {
        SettingsScreen()
            .environmentObject(appStateManager)
            .environmentObject(persistenceLocations)
            .settingsFrame()
            .padding()
            .zIndex(1)
        
    }
}









//MARK: - Preview
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(WeatherViewModel())
            .environmentObject(CoreLocationViewModel())
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())
    }
}

