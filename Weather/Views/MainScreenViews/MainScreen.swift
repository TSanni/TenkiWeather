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
    
    
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateManager: AppStateManager

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
                .transition(.offset(x: 1000))
            
            progresView
            
        }
        .redacted(reason: appStateManager.loading ? .placeholder : [])
//        .animation(.default, value: appStateManager.weatherTab)
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

    }
}




//MARK: - Main View Extension
extension MainScreen {
    
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
//            .environmentObject(SavedLocationsPersistence())
            .environmentObject(AppStateManager())
    }
}

