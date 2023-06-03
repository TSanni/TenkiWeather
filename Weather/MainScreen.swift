//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct MainScreen: View {
    @State private var selectedTab: WeatherTabs = .today
    
    func getBarColor() -> Color {
        switch selectedTab {
            case .today:
                return Color.indigo
            case .tomorrow:
                return Color.orange
            case .multiDay:
                return Color.blue
        }
    }
    
    var body: some View {
        ZStack {
//            Color.indigo.ignoresSafeArea()
            VStack(spacing: 0) {
                SearchBar()
                WeatherTabsView(weatherTab: $selectedTab)
                TabView(selection: $selectedTab) {
                    TodayScreen()
                        .ignoresSafeArea(edges: .bottom)
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .tag(WeatherTabs.today)
                    
                    TomorrowScreen()
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .tag(WeatherTabs.tomorrow)
                    
                    MultiDayScreen()
                        .contentShape(Rectangle()).gesture(DragGesture())
                        .tag(WeatherTabs.multiDay)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(getBarColor())
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
        MainScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        MainScreen()
            .previewDevice("iPhone SE (3rd generation)")
    }
}
