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

    @State var tabViews: WeatherTabs = .today

    var body: some View {
        let blendColor1 = appStateViewModel.mixColorWith70PercentWhite(themeColor: weatherViewModel.currentWeather.backgroundColor)
        
        ZStack {
            VStack(spacing: 0) {
//                SearchBar()
//                    .onTapGesture {
//                        appStateViewModel.toggleShowSearchScreen()
//                    }
                
//                WeatherTabSelectionsView(tabViews: $tabViews)
                
                
                                
                TabViews(tabViews: $tabViews)
                
                if !networkManager.isConnected {
                    HStack {
                        Image(systemName: "wifi.slash")
                        Text("No Internet Connection")
                    }
                    .foregroundStyle(.white)
                }
            }
            .zIndex(0)
            .background(getBarColor.brightness(-0.1).ignoresSafeArea())
            .disabled(appStateViewModel.showSettingScreen ? true : false)
            .animation(.default, value: tabViews)


//            blurBackGround
            
//            settingsTile
//                .transition(.offset(x: 1000))
            
            progresView
            
        }

        .redacted(reason: appStateViewModel.loading ? .placeholder : [])
        .animation(.default, value: appStateViewModel.showSettingScreen)
        .fullScreenCover(isPresented: $appStateViewModel.showSearchScreen) {
            NavigationView {
                SearchingScreen()
            }
            
        }
        .fullScreenCover(isPresented: $appStateViewModel.showSettingScreen) {
            NavigationView {
                SettingsScreen()
            }
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
        .onChange(of: appStateViewModel.resetViews) { _ in
            tabViews = .today
        }

    }
}




//MARK: - Main View Extension
extension MainScreen {
    
    private var getBarColor: Color {
        switch tabViews {
        case .today:
            return weatherViewModel.currentWeather.backgroundColor
        case .tomorrow:
            return weatherViewModel.tomorrowWeather.backgroundColor
        case .multiDay:
            return Color(uiColor: K.ColorsConstants.tenDayBarColor)
        }
    }
    
//    private var blurBackGround: some View {
//        Group {
//            if appStateViewModel.showSettingScreen {
//                Color.black.ignoresSafeArea().opacity(0.5)
//                    .onTapGesture {
//                            appStateViewModel.showSettingScreen = false
//                    }
//            }
//        }
//    }
    
    
//    @ViewBuilder
//    private var settingsTile: some View {
//        if appStateViewModel.showSettingScreen {
//            SettingsScreenTile()
//                .padding()
//                .zIndex(1)
//        }
//        
//    }
    
    @ViewBuilder
    private var progresView: some View {
        if appStateViewModel.loading {
            ProgressView()
        }
    }
}





//MARK: - Preview
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainScreen()
                .environmentObject(WeatherViewModel.shared)
                .environmentObject(CoreLocationViewModel.shared)
                .environmentObject(AppStateViewModel.shared)
                .environmentObject(NetworkMonitor())
                .environmentObject(SavedLocationsPersistenceViewModel.shared)
        }
    }
}

