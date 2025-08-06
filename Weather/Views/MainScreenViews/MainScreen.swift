//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation

//MARK: - View
struct MainScreen: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var networkManager: NetworkMonitor
    @EnvironmentObject var locationViewModel: CoreLocationViewModel
    @EnvironmentObject var savedLocationPersistenceViewModel: SavedLocationsPersistenceViewModel
    
    //Must use @State instead of view model because this is the only way to make animations work
    @State var tabViews: WeatherTabs = .today
    
    var deviceType: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        ZStack {
            getBackgroundColor.ignoresSafeArea()
            
            weatherEffectSceneView
                .ignoresSafeArea()
            
            if (weatherViewModel.currentWeather.isLightning && tabViews == .today) || (weatherViewModel.tomorrowWeather.isLightning && tabViews == .tomorrow) {
                LightningView().ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                
                SearchBar(backgroundColor: getBackgroundColor)
                    .padding(.vertical)
                
                WeatherTabSelectionsView(tabViews: $tabViews)
                
                TabViews(tabViews: $tabViews)
                    .tint(.white)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea()
                
                
                if !networkManager.isConnected {
                    HStack {
                        Image(systemName: "wifi.slash")
                        Text("No Internet Connection")
                    }
                    .foregroundStyle(.white)
                }
            }
            .zIndex(0)
            .disabled(appStateViewModel.showSettingScreen ? true : false)
            .animation(deviceType == .pad ? nil : .default, value: tabViews)
            
            progressView
            
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .redacted(reason: appStateViewModel.loading ? .placeholder : [])
        .fullScreenCover(isPresented: $appStateViewModel.showSearchScreen) {
            NavigationStack {
                SearchingScreenView()
            }
        }
        .sheet(isPresented: $appStateViewModel.showSettingScreen) {
            NavigationStack {
                SettingsScreen()
            }
        }
        .alert(isPresented: $appStateViewModel.showWeatherErrorAlert, error: appStateViewModel.weatherError) { _ in
            Button("OK", role: .cancel) { }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
        }
        .alert(isPresented: $savedLocationPersistenceViewModel.showErrorAlert, error: savedLocationPersistenceViewModel.currentError) { _ in
            Button("OK", role: .cancel) { }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
        }
        .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
            tabViews = .today
        }
        .onChange(of: locationViewModel.authorizationStatus) { oldValue, newValue in
            switch newValue {
            case .authorizedWhenInUse:
                if oldValue != newValue && oldValue != nil {
                    Task {
                        await appStateViewModel.determineWeatherUpdateMethod()
                    }
                }
            default: break
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            //use this modifier to periodically update the weather data
            switch newValue {
            case .active:
                Task {
                    await appStateViewModel.handleForegroundEntry()
                }
                
            default:
                break
            }
        }
        .environmentObject(weatherViewModel)
        .environmentObject(savedLocationPersistenceViewModel)
        .environmentObject(locationViewModel)
        .environmentObject(appStateViewModel)
        .environmentObject(networkManager)
    }
}

//MARK: - Main View Extension
extension MainScreen {
    
    private var getBackgroundColor: Color {
        switch tabViews {
        case .today:
            return weatherViewModel.currentWeather.backgroundColor
        case .tomorrow:
            return weatherViewModel.tomorrowWeather.backgroundColor
        case .multiDay:
            return Color.tenDayBarColor
        }
    }
    
    @ViewBuilder
    private var weatherEffectSceneView: some View {
        switch tabViews {
        case .today:
            weatherViewModel.currentWeather.scene
        case .tomorrow:
            weatherViewModel.tomorrowWeather.scene
        case .multiDay:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        if appStateViewModel.loading {
            ProgressView()
        }
    }
}

//MARK: - Preview
#Preview {
    NavigationStack {
        MainScreen()
            .environmentObject(WeatherViewModel.preview)
            .environmentObject(CoreLocationViewModel.preview)
            .environmentObject(NetworkMonitor.preview)
            .environmentObject(SavedLocationsPersistenceViewModel.preview)
            .environmentObject(LocationSearchViewModel.preview)
            .environmentObject(AppStateViewModel.preview)
            
    }
}
