//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation


// Main screens get environment objects. Lesser views get passed in data

struct MainScreen: View {
    @StateObject private var vm = WeatherKitManager()
    @State private var selectedTab: WeatherTabs = .today
    
    func getBarColor() -> Color {
        switch selectedTab {
            case .today:
                return vm.currentWeather.backgroundColor
            case .tomorrow:
                return vm.tomorrowWeather.backgroundColor
            case .multiDay:
                return Color.blue
        }
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    getBarColor().brightness(-0.1)
                    Color(red: 0.15, green: 0.15, blue: 0.15)
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    VStack {
                        ZStack(alignment: .trailing) {
                            NavigationLink {
                                SearchingScreen()
                                    .environmentObject(vm)
                            } label: {
                                SearchBar()
                                    .environmentObject(vm)
                            }
                            
                            Circle().fill(Color.red)
                                .frame(width: 30)
                                .padding(.trailing)
                                .onTapGesture {
                                    print("Circle tapped")
                                }
                        }
                        
                        WeatherTabsView(weatherTab: $selectedTab)
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    TabView(selection: $selectedTab) {
                        TodayScreen(currentWeather: vm.currentWeather)
                            .ignoresSafeArea(edges: .bottom)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.today)
                            .environmentObject(vm)
                        
                        TomorrowScreen(tomorrowWeather: vm.tomorrowWeather)
                            .ignoresSafeArea(edges: .bottom)
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.tomorrow)
                            .environmentObject(vm)

                        
                        MultiDayScreen()
                            .contentShape(Rectangle()).gesture(DragGesture())
                            .tag(WeatherTabs.multiDay)
                            .environmentObject(vm)

                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .task {
            await vm.getWeather()
        }
        

    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 12 Pro Max")
        
        MainScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        MainScreen()
            .previewDevice("iPhone SE (3rd generation)")
    }
}
