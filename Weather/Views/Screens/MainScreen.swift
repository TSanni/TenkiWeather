//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.

import SwiftUI
import WeatherKit
import CoreLocation

//MARK: - View
struct MainScreen: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var locationViewModel: CoreLocationViewModel
    @EnvironmentObject var savedLocationPersistenceViewModel: SavedLocationsPersistenceViewModel
    @EnvironmentObject var networkManager: NetworkMonitor
        
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabScreens()
                    .redacted(reason: appStateViewModel.loading ? .placeholder : [])
                    .tint(.primary)
                
                NoInternetView()
            }
            
            progressView
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .toolbarModifier()
        .fullScreenCover(isPresented: $appStateViewModel.showSearchScreen) {
            NavigationStack {
                SearchingScreenView()
            }
        }
        .fullScreenCover(isPresented: $appStateViewModel.showSettingScreen) {
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
    }
}

//MARK: - Main View Extension
extension MainScreen {
    
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
