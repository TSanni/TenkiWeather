//
//  TabViews.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/26/24.
//

import SwiftUI

struct TabViews: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @Binding var tabViews: WeatherTabs

    var body: some View {
        TabView(selection: $tabViews) {
            
            
            TodayScreen(currentWeather: weatherViewModel.currentWeather, weatherAlert: weatherViewModel.weatherAlert)
                .tag(WeatherTabs.today)
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
            
            TomorrowScreen(dailyWeather: weatherViewModel.tomorrowWeather)
                .tag(WeatherTabs.tomorrow)
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
            
            MultiDayScreen(daily: weatherViewModel.dailyWeather)
                .tag(WeatherTabs.multiDay)
                .edgesIgnoringSafeArea(.bottom)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.bottom)

    }
}

#Preview {
    TabViews( tabViews: .constant(.today))
        .environmentObject(WeatherViewModel.shared)
        .environmentObject(AppStateViewModel.shared)
}
