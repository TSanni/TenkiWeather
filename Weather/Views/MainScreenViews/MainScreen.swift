//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation
import SpriteKit

//MARK: - View
struct MainScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var networkManager: NetworkMonitor
    @EnvironmentObject var locationViewModel: CoreLocationViewModel
    @EnvironmentObject var savedLocationPersistenceViewModel: SavedLocationsPersistenceViewModel
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    
    //Must use @State instead of view model because this is the only way to make animations work
    @State var tabViews: WeatherTabs = .today
    @State private var savedDate = Date()
    
    let backgroundClass = BackgroundTasksManager()
    var deviceType: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }

    
    var body: some View {
        ZStack {
            getBackgroundColor.ignoresSafeArea()
            
            weatherEffectSceneView
            
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
        
        .alert(isPresented: $weatherViewModel.showErrorAlert, error: weatherViewModel.currentError) { _ in
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
        .task {
            if locationViewModel.authorizationStatus == .authorizedWhenInUse {
                await appStateViewModel.getWeather()
            }
        }
        .onChange(of: locationViewModel.authorizationStatus) { oldValue, newValue in
            switch newValue {
            case .authorizedWhenInUse:
                Task {
                    await appStateViewModel.getWeather()
                }
            default: break
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            //use this modifier to periodically update the weather data
            switch newValue {
            case .active:
                Task {
                    if -savedDate.timeIntervalSinceNow > 60 * 10 {
                        // 10 minutes have passed, refresh the data
                        await appStateViewModel.getWeather()
                        await savedLocationPersistenceViewModel.callFetchWeatherPlacesWithTaskGroup()
                        savedDate = Date()
                    }
                }
                
            case .background: backgroundClass.startBackgroundTasks()
            default: break
            }
        }
        .environmentObject(weatherViewModel)
        .environmentObject(savedLocationPersistenceViewModel)
        .environmentObject(locationViewModel)
        .environmentObject(appStateViewModel)
        .environmentObject(networkManager)
        .environmentObject(locationSearchViewModel)
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
            return K.ColorsConstants.tenDayBarColor
        }
    }
    
    @ViewBuilder
    private var weatherEffectSceneView: some View {
        switch tabViews {
        case .today:
            if let scene = weatherViewModel.currentWeather.scene {
                WeatherParticleEffectView(sceneImport: scene)
            }
        case .tomorrow:
            if let scene = weatherViewModel.tomorrowWeather.scene {
                WeatherParticleEffectView(sceneImport: scene)
            }
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
