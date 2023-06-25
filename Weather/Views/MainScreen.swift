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
    @StateObject private var vm = WeatherViewModel()
    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @StateObject private var locationManager = CoreLocationViewModel()

    @State private var weatherTab: WeatherTabs = .today
    @State private var showSearchScreen: Bool = false
    //@State can survive reloads on the `View`
    @State private var taskId: UUID = .init()
    
    
    func getBarColor() -> Color {
        switch weatherTab {
            case .today:
                return vm.currentWeather.backgroundColor
            case .tomorrow:
                return vm.tomorrowWeather.backgroundColor
            case .multiDay:
                return Color(uiColor: K.Colors.tenDayBarColor)
        }
    }
    
    var body: some View {
        
        
        VStack {
            if showSearchScreen {
                SearchingScreen(showSearchScreen: $showSearchScreen, todayCollection: persistenceLocations.savedLocations)
                    .transition(.move(edge: .bottom))
                    .environmentObject(persistenceLocations)
                    .environmentObject(vm)
                    .environmentObject(locationManager)
            } else {
                ZStack {
                    VStack(spacing: 0) {
                        getBarColor().brightness(-0.1)
                        Color(uiColor: K.Colors.properBlack)
                    }
                    .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        
                        VStack {
                            ZStack(alignment: .trailing) {
                                
                                SearchBar()
                                    .onTapGesture {
                                        showSearchScreen.toggle()
                                    }
                                    .environmentObject(vm)
                                    .environmentObject(locationManager)

                                
                                Circle().fill(Color.red)
                                    .frame(width: 30)
                                    .padding(.trailing)
                                    .onTapGesture {
                                        print("Circle tapped")
                                        persistenceLocations.addFruit(lat: 48.856613, lon: 2.352222) // Paris coordinates
                                        persistenceLocations.fetchLocations()
                                    }
                            }
                            
                            Button("TAP") {
                                persistenceLocations.addFruit(lat: 43.062096, lon: 141.354370) // Sapporo Coordinates
                                persistenceLocations.fetchLocations()
                            }
                            Text(locationManager.currentLocationName)
                                .font(.largeTitle)
                            
                            WeatherTabSelectionsView(weatherTab: $weatherTab)
                                .padding(.top, 10)
                        }
                        .padding(.horizontal)
                        
                        TabView(selection: $weatherTab) {
                            Text("Hi there") // <-- Need this here for TabView to function properly
                            
                            TodayScreen(currentWeather: vm.currentWeather)
                                .tabItem {
                                    Label("Today", systemImage: "house")
                                }
                                .tag(WeatherTabs.today)
                                .ignoresSafeArea(edges: .bottom)
                                .contentShape(Rectangle()).gesture(DragGesture())
                                .environmentObject(vm)
                            
                            TomorrowScreen(tomorrowWeather: vm.tomorrowWeather)
                                .tabItem {
                                    Label("Tomorrow", systemImage: "house")
                                }
                                .tag(WeatherTabs.tomorrow)
                                .ignoresSafeArea(edges: .bottom)
                                .contentShape(Rectangle()).gesture(DragGesture())
                                .environmentObject(vm)

                            
                            MultiDayScreen(daily: vm.dailyWeather)
                                .tabItem {
                                    Label("10 Days", systemImage: "house")
                                }
                                .tag(WeatherTabs.multiDay)
                                .contentShape(Rectangle()).gesture(DragGesture())
                                .environmentObject(vm)
                            
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .ignoresSafeArea(edges: .bottom)
                }

            }
        }
        .animation(nil, value: showSearchScreen)
        .navigationViewStyle(.stack)
        .refreshable {
            print("refreshable")
            //Cause .task to re-run by changing the id.
            taskId = .init()
        }
        .task(id: taskId) {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                await vm.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let userLocationName = locationManager.currentLocationName
                await vm.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName)

                persistenceLocations.saveData()
            }
        }

        .onChange(of: locationManager.authorizationStatus) { newValue in
            if newValue == .authorizedWhenInUse {
                Task {
                    await vm.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    let userLocationName = locationManager.currentLocationName
                    await vm.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName)
             
                    persistenceLocations.saveData()

                }
            }
        }

        
//        if locationManager.authorizationStatus == .authorizedWhenInUse {
//
//            VStack {
//                if showSearchScreen {
//                    SearchingScreen(showSearchScreen: $showSearchScreen, todayCollection: persistenceLocations.allWeather)
//                        .transition(.move(edge: .bottom))
//                        .environmentObject(persistenceLocations)
//                } else {
//                    ZStack {
//                        VStack(spacing: 0) {
//                            getBarColor().brightness(-0.1)
//                            Color(uiColor: K.Colors.properBlack)
//                        }
//                        .ignoresSafeArea()
//
//                        VStack(spacing: 0) {
//
//                            VStack {
//                                ZStack(alignment: .trailing) {
//
//                                    SearchBar()
//                                        .onTapGesture {
//                                            showSearchScreen.toggle()
//                                        }
//                                        .environmentObject(vm)
//
//
//                                    Circle().fill(Color.red)
//                                        .frame(width: 30)
//                                        .padding(.trailing)
//                                        .onTapGesture {
//                                            print("Circle tapped")
//                                            persistenceLocations.addFruit(lat: 48.856613, lon: 2.352222) // Paris coordinates
//                                        }
//                                }
//
//                                Button("TAP") {
//                                    persistenceLocations.addFruit(lat: 43.062096, lon: 141.354370) // Sapporo Coordinates
//                                }
//
//                                WeatherTabSelectionsView(weatherTab: $weatherTab)
//                                    .padding(.top, 10)
//                            }
//                            .padding(.horizontal)
//
//                            TabView(selection: $weatherTab) {
//                                Text("Hi there") // <-- Need this here for TabView to function properly
//
//                                TodayScreen(currentWeather: vm.currentWeather)
//                                    .tabItem {
//                                        Label("Today", systemImage: "house")
//                                    }
//                                    .tag(WeatherTabs.today)
//                                    .ignoresSafeArea(edges: .bottom)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
//                                    .environmentObject(vm)
//
//                                TomorrowScreen(tomorrowWeather: vm.tomorrowWeather)
//                                    .tabItem {
//                                        Label("Tomorrow", systemImage: "house")
//                                    }
//                                    .tag(WeatherTabs.tomorrow)
//                                    .ignoresSafeArea(edges: .bottom)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
//                                    .environmentObject(vm)
//
//
//                                MultiDayScreen(daily: vm.dailyWeather)
//                                    .tabItem {
//                                        Label("10 Days", systemImage: "house")
//                                    }
//                                    .tag(WeatherTabs.multiDay)
//                                    .contentShape(Rectangle()).gesture(DragGesture())
//                                    .environmentObject(vm)
//
//                            }
//                            .tabViewStyle(.page(indexDisplayMode: .never))
//                        }
//                        .ignoresSafeArea(edges: .bottom)
//                    }
//
//                }
//            }
//            .animation(nil, value: showSearchScreen)
//            .navigationViewStyle(.stack)
//            .task {
//                print("HAHAH")
//                print(locationManager.latitude)
//                print(locationManager.longitude)
//                await vm.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude)
//            }
//            .refreshable {
//
//            }
//        } else {
//            ZStack {
//                Color(uiColor: K.Colors.dayTimeCloudy).ignoresSafeArea()
//                ProgressView()
//            }
//            .onAppear {
//                print("on appear called")
//                locationManager.locationManager.requestWhenInUseAuthorization()
//            }
//        }

        
        
        
        

        

        
        
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainScreen()
                .previewDevice("iPhone 12 Pro Max")
                .environmentObject(WeatherViewModel())
        }
        
        MainScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        MainScreen()
            .previewDevice("iPhone SE (3rd generation)")
    }
}
