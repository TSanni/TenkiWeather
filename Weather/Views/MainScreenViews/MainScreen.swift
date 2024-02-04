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
    
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var persistenceLocations: SavedLocationsPersistence
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager
    
    @State private var savedDate = Date()
    
    
    
    var body: some View {
        ZStack {
            
            
            VStack(spacing: 0) {
                SearchBar().onTapGesture { appStateManager.showSearchScreen = true }
                
                WeatherTabSelectionsView()
                
                TabViews()
                
            }
            .background(getBarColor.brightness(-0.1).ignoresSafeArea())
            .zIndex(0)
            .disabled(appStateManager.showSettingScreen ? true : false)
            
            blurBackGround
            
            settingsTile
                .transition(.move(edge: .trailing))

            
            progresView
            
        }
        .redacted(reason: appStateManager.loading ? .placeholder : [])
        .animation(.default, value: appStateManager.weatherTab)
        .animation(.default, value: appStateManager.showSettingScreen)
        .fullScreenCover(isPresented: $appStateManager.showSearchScreen) {
            SearchingScreen()
            
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
            symbol: weatherViewModel.currentWeather.symbol,
            weatherCondition: weatherViewModel.currentWeather.weatherDescription.description
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
                    .onTapGesture {
                            appStateManager.showSettingScreen = false
                    }
            }
        }
    }
    
    
    @ViewBuilder
    private var settingsTile: some View {
        if appStateManager.showSettingScreen {
            SettingsScreenTile()
                .settingsFrame()
                .padding()
                .zIndex(1)
        }
        
    }
    
    @ViewBuilder
    private var progresView: some View {
        if appStateManager.loading {
            ProgressView()
        }
    }
}





//MARK: - Preview
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(WeatherViewModel())
            .environmentObject(CoreLocationViewModel())
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())
    }
}

