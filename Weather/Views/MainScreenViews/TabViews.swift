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
            TodayScreen(currentWeather: weatherViewModel.currentWeather, dailyWeather: weatherViewModel.dailyWeather, weatherAlert: weatherViewModel.weatherAlert)
                .tag(WeatherTabs.today)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
                .tabItem {
                    LabelView(title: "Today", iconSymbol: weatherViewModel.currentWeather.symbolName)
                }
                .toolbar(.visible, for: .tabBar)
            
            TomorrowScreen(dailyWeather: weatherViewModel.tomorrowWeather)
                .tag(WeatherTabs.tomorrow)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
                .toolbar(.visible, for: .tabBar)
                .tabItem {
                    LabelView(title: "Tomorrow", iconSymbol: weatherViewModel.tomorrowWeather.symbolName)
                }
            
            MultiDayScreen(daily: weatherViewModel.dailyWeather)
                .tag(WeatherTabs.multiDay)
                .environmentObject(weatherViewModel)
                .environmentObject(appStateViewModel)
                .toolbar(.visible, for: .tabBar)
                .tabItem {
                    LabelView(title: "10 Day", iconSymbol: "list.bullet.rectangle.fill")
                }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: WeatherTabs = .today

    NavigationStack {
        TabViews( tabViews: $selectedTab)
            .environmentObject(WeatherViewModel.preview)
            .environmentObject(AppStateViewModel.preview)
    }
}
