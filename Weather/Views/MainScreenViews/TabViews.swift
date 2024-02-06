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
                .tag(WeatherTabs.today)
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .contentShape(Rectangle()).gesture(DragGesture())
            
            
            TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                .tag(WeatherTabs.tomorrow)
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateManager)
                .contentShape(Rectangle()).gesture(DragGesture())

            
            MultiDayScreen(daily: weatherViewModel.dailyWeather)
                .tag(WeatherTabs.multiDay)
                .edgesIgnoringSafeArea(.bottom)
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
