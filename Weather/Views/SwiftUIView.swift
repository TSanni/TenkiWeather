//
//  SwiftUIView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/20/23.
//

import SwiftUI

struct SwiftUIView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @StateObject private var locationManager = CoreLocationViewModel()
    @StateObject private var appStateManager = AppStateManager()
    
    @State private var savedDate = Date()
    @State private var weatherTab: WeatherTabs = .today
    @State private var redraw: Bool = true
    
    //@State can survive reloads on the `View`
    @State private var taskId: UUID = .init()
    @Namespace var namespace
    
    
    var body: some View {
        TabView(selection: $weatherTab) {
            Group {
                
                TodayScreen(currentWeather: weatherViewModel.currentWeather)
                    .tabItem {
                        Label("Today", systemImage: "sun.min")
                    }
                    .tag(WeatherTabs.today)
                    .environmentObject(weatherViewModel)
                
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
            .onAppear {
                /// Need this onAppear method to remedy a bug where the tab selection does not change tab
                let holderTab = weatherTab
                weatherTab = .today
                weatherTab = holderTab
            }
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
