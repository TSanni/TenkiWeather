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
    //Must use @State instead of view model because this is the only way to make animations work
    @State var tabViews: WeatherTabs = .today
    let deviceType = UIDevice.current.userInterfaceIdiom

    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
//                SearchBar()
//                    .onTapGesture {
//                        appStateViewModel.toggleShowSearchScreen()
//                    }
                
                TopView().padding(.vertical)
                
                if UIDevice.current.userInterfaceIdiom != .pad {
                    WeatherTabSelectionsView(tabViews: $tabViews)
                    TabViews(tabViews: $tabViews)
                        .tint(.white)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea()
                } else {
                    TabViews(tabViews: $tabViews)
                        .tint(.white)
                        .ignoresSafeArea()
                }


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
            .animation(deviceType == .pad ? nil : .default, value: tabViews)


//            blurBackGround
            
//            settingsTile
//                .transition(.offset(x: 1000))
            
            progresView
            
        }

        .redacted(reason: appStateViewModel.loading ? .placeholder : [])
        .animation(.default, value: appStateViewModel.showSettingScreen)
        .fullScreenCover(isPresented: $appStateViewModel.showSearchScreen) {
            NavigationStack {
                SearchingScreen()
            }
            .navigationViewStyle(.stack)
            
        }
        .fullScreenCover(isPresented: $appStateViewModel.showSettingScreen) {
            NavigationStack {
                SettingsScreen()
            }
            .navigationViewStyle(.stack)

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
        .navigationViewStyle(.stack)

    }
}

