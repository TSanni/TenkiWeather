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
    @StateObject private var vm = WeatherKitManager()
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
        
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    getBarColor()
                    Color(red: 0.15, green: 0.15, blue: 0.15)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VStack {
                        ZStack(alignment: .trailing) {
                            NavigationLink {
                                SearchingScreen()
                            } label: {
                                SearchBar()
                            }
                            
                            Circle().fill(Color.red)
                                .frame(width: 30)
                                .padding(.trailing)
                                .onTapGesture {
                                    print("Circle tapped")
                                }
                        }
                        
                        WeatherTabsView(weatherTab: $selectedTab)
                    }
                    .padding(.horizontal)
                    
                    TabView(selection: $selectedTab) {
                        TodayScreen()
                            .ignoresSafeArea(edges: .bottom)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.today)
                            .environmentObject(vm)
                        
                        TomorrowScreen()
                            .ignoresSafeArea(edges: .bottom)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.tomorrow)
                        
                        MultiDayScreen()
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.multiDay)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
//        .task {
//            await vm.getWeather()
//            print("Sapporo Temp: \(vm.currentWeather.currentTemperature)")
//            print("Sapporo Date? \(vm.currentWeather.date)")
//        }
        

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
