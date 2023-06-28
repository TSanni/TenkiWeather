//
//  MainScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI
import WeatherKit
import CoreLocation

class AppStateManager: ObservableObject {
    @Published var showSearchScreen: Bool = false
    @Published var searchNameIsInPlacesArray: Bool = true
}


// Main screens get environment objects. Lesser views get passed in data
//TODO: Adding currentLocationName property from CoreLocationViewModel ANYWHERE in this view breaks the app. Find a way to fix

struct MainScreen: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    //    @StateObject private var persistenceLocations = SavedLocationsPersistence()
    @Environment(\.managedObjectContext) var moc
    
    @StateObject private var locationManager = CoreLocationViewModel()
    @StateObject private var appStateManager = AppStateManager()
    
    @State private var weatherTab: WeatherTabs = .today
    @State private var redraw: Bool = true
    //    @State private var showSearchScreen: Bool = false
    
    //@State can survive reloads on the `View`
    @State private var taskId: UUID = .init()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)], animation: .easeInOut) var places: FetchedResults<LocationEntity>
    
    
    
    func getBarColor() -> Color {
        switch weatherTab {
            case .today:
                return weatherViewModel.currentWeather.backgroundColor
            case .tomorrow:
                return weatherViewModel.tomorrowWeather.backgroundColor
            case .multiDay:
                return Color(uiColor: K.Colors.tenDayBarColor)
        }
    }
    
    var barColor: some View {
        VStack(spacing: 0) {
            getBarColor().brightness(-0.1)
            Color(uiColor: K.Colors.properBlack)
        }
        .ignoresSafeArea()
        
    }
    
    
    var searchBar: some View {
        ZStack(alignment: .trailing) {
            
            SearchBar()
                .onTapGesture {
                    appStateManager.showSearchScreen.toggle()
                }
                .environmentObject(weatherViewModel)
                .environmentObject(locationManager)
            
            
            Circle().fill(Color.red)
                .frame(width: 30)
                .padding(.trailing)
                .onTapGesture {
                    print("Circle tapped")
                    //                    persistenceLocations.addFruit(lat: 48.856613, lon: 2.352222, timezone: 7200) // Paris coordinates
                    //                    persistenceLocations.fetchLocations()
                }
        }
    }
    
    
    var testButtons: some View {
        HStack {
            Button("Sapporo") {
                //                persistenceLocations.addFruit(name: "Sapporo", lat: 43.062096, lon: 141.354370, timezone: 32400) // Sapporo Coordinates
                
                let newPlace = LocationEntity(context: moc)
                newPlace.name = "Sapporo"
                newPlace.latitude = 43.062096
                newPlace.longitude = 141.354370
                newPlace.timezone = 32400
                newPlace.sfSymbol = "snowflake"
                
                try? moc.save()
            }
            
            Button("Houston") {
                //                persistenceLocations.addFruit(name: "Houston", lat: 29.760427, lon: -95.369804, timezone: -18000) // Houston Coordinates
                let newPlace = LocationEntity(context: moc)
                newPlace.name = "Houston, TX, United States"
                newPlace.latitude = 29.760427
                newPlace.longitude = -95.369804
                newPlace.timezone = -18000
                newPlace.sfSymbol = "cloud"
                
                
                try? moc.save()
            }
            
            Button("Paris") {
                //                persistenceLocations.addFruit(name: "Paris", lat: 48.856613, lon: 2.352222, timezone: 7200) // Paris coordinates
                let newPlace = LocationEntity(context: moc)
                newPlace.name = "Paris"
                newPlace.latitude = 48.856613
                newPlace.longitude = 2.352222
                newPlace.timezone = 7200
                newPlace.sfSymbol = "sun.min"
                
                try? moc.save()
            }
            
            Button("Los Angeles") {
                //                persistenceLocations.addFruit(name: "Los Angeles", lat: 34.052235, lon: -118.243683, timezone: -25200) // Los Angeles
                let newPlace = LocationEntity(context: moc)
                newPlace.name = "Los Angeles"
                newPlace.latitude = 34.052235
                newPlace.longitude = -118.243683
                newPlace.timezone = -25200
                newPlace.sfSymbol = "cloud.bolt.rain"
                
                try? moc.save()
            }
        }
    }
    
    
    var body: some View {
        
        //        VStack {
        //            if !appStateManager.showSearchScreen {
        //                ZStack {
        //                    barColor
        //
        //                    VStack(spacing: 0) {
        //
        //                        VStack {
        //
        //                            searchBar
        //
        //                            testButtons
        //
        //                            WeatherTabSelectionsView(weatherTab: $weatherTab)
        //                                .padding(.top, 10)
        //                        }
        //                        .padding(.horizontal)
        //
        //                        TabView(selection: $weatherTab) {
        //                            //                            Text("Hi there") // <-- Need this here for TabView to function properly
        //
        //                            TodayScreen(currentWeather: weatherViewModel.currentWeather)
        //                                .tabItem {
        //                                    Label("Today", systemImage: "house")
        //                                }
        //                                .tag(WeatherTabs.today)
        //                                .ignoresSafeArea(edges: .bottom)
        //                                .contentShape(Rectangle()).gesture(DragGesture())
        //                                .environmentObject(weatherViewModel)
        //
        //                            TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
        //                                .tabItem {
        //                                    Label("Tomorrow", systemImage: "house")
        //                                }
        //                                .tag(WeatherTabs.tomorrow)
        //                                .ignoresSafeArea(edges: .bottom)
        //                                .contentShape(Rectangle()).gesture(DragGesture())
        //                                .environmentObject(weatherViewModel)
        //
        //
        //                            MultiDayScreen(daily: weatherViewModel.dailyWeather)
        //                                .tabItem {
        //                                    Label("10 Days", systemImage: "house")
        //                                }
        //                                .tag(WeatherTabs.multiDay)
        //                                .contentShape(Rectangle()).gesture(DragGesture())
        //                                .environmentObject(weatherViewModel)
        //
        //                        }
        //                        .tabViewStyle(.page(indexDisplayMode: .never))
        //                    }
        //                    .ignoresSafeArea(edges: .bottom)
        //                }
        //
        //            } else {
        //
        //                SearchingScreen()
        //                    .transition(.move(edge: .bottom))
        ////                    .environmentObject(persistenceLocations)
        //                    .environmentObject(weatherViewModel)
        //                    .environmentObject(locationManager)
        //                    .environmentObject(appStateManager)
        //            }
        //        }
        
        
        Group {
            if appStateManager.showSearchScreen {
                SearchingScreen(places: places, testMOC: moc)
                //                    .transition(.move(edge: .bottom))
                    .environmentObject(weatherViewModel)
                    .environmentObject(appStateManager)
                    .environmentObject(locationManager)
            } else {
                
                VStack(spacing: 0) {
                    
                    SearchBar()
                        .environmentObject(weatherViewModel)
                        .environmentObject(locationManager)
                        .onTapGesture {
                            appStateManager.showSearchScreen = true
                        }
                        .padding()
                    
                    testButtons
                    
                    Text("\(places.count)")
                    
                    WeatherTabSelectionsView(weatherTab: $weatherTab)
                    
                    TabView(selection: $weatherTab) {
                        Group {
                            
                            TodayScreen(currentWeather: weatherViewModel.currentWeather)
                                .tag(WeatherTabs.today)
                                .environmentObject(weatherViewModel)
                                .contentShape(Rectangle()).gesture(DragGesture())
                            
                            TomorrowScreen(tomorrowWeather: weatherViewModel.tomorrowWeather)
                                .tag(WeatherTabs.tomorrow)
                                .environmentObject(weatherViewModel)
                                .contentShape(Rectangle()).gesture(DragGesture())
                            
                            MultiDayScreen(daily: weatherViewModel.dailyWeather)
                                .tag(WeatherTabs.multiDay)
                                .environmentObject(weatherViewModel)
                                .contentShape(Rectangle()).gesture(DragGesture())
                        }
                        .onAppear {
                            /// Need this onAppear method to remedy a bug where the tab selection does not change tab
                            let test = weatherTab
                            weatherTab = .today
                            weatherTab = test
                        }
                        
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
                .background(getBarColor().brightness(-0.1).ignoresSafeArea())
                //                .transition(.move(edge: .bottom))
                
            }
        }
        .animation(.linear, value: appStateManager.showSearchScreen)
        .refreshable {
            print("refreshable")
            //Cause .task to re-run by changing the id.
            taskId = .init()
        }
        .task(id: taskId) {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let timezone = locationManager.timezoneForCoordinateInput
                await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                let userLocationName = locationManager.currentLocationName
                await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
                
                //                persistenceLocations.saveData()
                
            }
        }
        .onChange(of: locationManager.authorizationStatus) { newValue in
            if newValue == .authorizedWhenInUse {
                Task {
                    await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    let timezone = locationManager.timezoneForCoordinateInput
                    await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                    let userLocationName = locationManager.currentLocationName
                    await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
                    
                    //                    persistenceLocations.saveData()
                }
            }
        }
        
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(WeatherViewModel())
        
        MainScreen()
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        MainScreen()
            .previewDevice("iPhone SE (3rd generation)")
    }
}
