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
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var networkManager: NetworkMonitor
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var savedLocationPersistenceViewModel: SavedLocationsPersistenceViewModel
    //Must use @State instead of view model because this is the only way to make animations work
    @State var tabViews: WeatherTabs = .today
    let deviceType = UIDevice.current.userInterfaceIdiom

    var body: some View {
        ZStack {
            getBackgroundColor.ignoresSafeArea()
            
            getScene
            
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
            
            progresView
            
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
            
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
        }
        .alert(isPresented: $savedLocationPersistenceViewModel.showErrorAlert, error: savedLocationPersistenceViewModel.currentError) { _ in
            
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
        }
        .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
            tabViews = .today
        }
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
    private var getScene: some View {
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
    private var progresView: some View {
        if appStateViewModel.loading {
            ProgressView()
        }
    }
}

//MARK: - Preview
#Preview {
    NavigationStack {
        MainScreen()
            .environmentObject(WeatherViewModel.shared)
            .environmentObject(CoreLocationViewModel.shared)
            .environmentObject(AppStateViewModel.shared)
            .environmentObject(NetworkMonitor())
            .environmentObject(SavedLocationsPersistenceViewModel.shared)
            .environmentObject(LocationSearchViewModel())
    }
}
