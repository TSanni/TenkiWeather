//
//  TabScreens.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/26/24.
//

import SwiftUI

struct TabScreens: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @Binding var tabViews: WeatherTabs

    var body: some View {
        TabView(selection: $tabViews) {
            Tab("Today", systemImage: weatherViewModel.currentWeather.symbolName, value: WeatherTabs.today) {
                TodayScreen(currentWeather: weatherViewModel.currentWeather, dailyWeather: weatherViewModel.dailyWeather, weatherAlert: weatherViewModel.weatherAlert)
            }
            
            Tab("Tomorrow", systemImage: weatherViewModel.tomorrowWeather.symbolName, value: WeatherTabs.tomorrow) {
                TomorrowScreen(dailyWeather: weatherViewModel.tomorrowWeather)
            }
            
            Tab("10 Days", systemImage: "list.dash", value: WeatherTabs.multiDay) {
                MultiDayScreen(daily: weatherViewModel.dailyWeather)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: WeatherTabs = .today

    NavigationStack {
        TabScreens( tabViews: $selectedTab)
            .environmentObject(WeatherViewModel.preview)
            .environmentObject(AppStateViewModel.preview)
    }
}
