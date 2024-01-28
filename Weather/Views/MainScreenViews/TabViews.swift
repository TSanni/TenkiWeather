//
//  TabViews.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/26/24.
//

import SwiftUI

struct TabViews: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        TabView(selection: $appStateManager.weatherTab) {
            
            
            TodayScreen(currentWeather: weatherViewModel.currentWeather, weatherAlert: weatherViewModel.weatherAlert)
                .tabItem {
                    Label("Today", systemImage: "sun.min")
                }
                .edgesIgnoringSafeArea(.bottom)
                .tag(WeatherTabs.today)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .contentShape(Rectangle()).gesture(DragGesture())
            
            
            TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                .tabItem {
                    Label("Tomorrow", systemImage: "snow")
                }
                .edgesIgnoringSafeArea(.bottom)
                .tag(WeatherTabs.tomorrow)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .contentShape(Rectangle()).gesture(DragGesture())

            
            MultiDayScreen(daily: weatherViewModel.dailyWeather)
                .tabItem {
                    Label("10 Days", systemImage: "cloud")
                }
                .edgesIgnoringSafeArea(.bottom)
                .tag(WeatherTabs.multiDay)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .contentShape(Rectangle()).gesture(DragGesture())

        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.bottom)

    }
}

#Preview {
    TabViews()
        .environmentObject(WeatherViewModel())
        .environmentObject(AppStateManager())
}
