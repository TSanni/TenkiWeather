//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreen: View {
//    @State private var searchText: String = ""
    @State private var showGoogleSearchScreen: Bool = false
//    @FocusState private var focusSearch: Bool
    @Environment(\.colorScheme) var colorScheme
//    @EnvironmentObject var persistenceLocations: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager
    
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            VStack {
                currentLocation
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                CustomDivider()
                
                SavedLocationsView()
            }
            .padding()
        }
        .contentShape(Rectangle())
//        .onAppear {
//            focusSearch = true
//        }
        .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)
        .sheet(isPresented: $showGoogleSearchScreen) {
            PlacesViewControllerBridge { place in
                Task {
                    
                    let coordinates = place.coordinate
                    await locationManager.getNameFromCoordinates(latitude: coordinates.latitude, longitude: coordinates.longitude, nameFromGoogleAPI: place.name)
                    let timezone = locationManager.timezoneForCoordinateInput

                    await weatherViewModel.getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
                    
                    
                    appStateManager.setSearchedLocationDictionary(
                        name: locationManager.currentLocationName,
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude,
                        timezone: timezone,
                        temperature: weatherViewModel.currentWeather.currentTemperature,
                        date: weatherViewModel.currentWeather.date,
                        symbol: weatherViewModel.currentWeather.symbol
                    )
                    
                    
                    
                    appStateManager.showSearchScreen = false
                }

            }
        }
   
    }
    
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
//                focusSearch = false
                appStateManager.showSearchScreen = false
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .padding()
            }
            
            Text("Search for a location")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
                .onTapGesture {
                    showGoogleSearchScreen = true
                }
            
            /*

//            TextField("Search for a location", text: $searchText)
//                .focused($focusSearch)
//                .tint(Color(uiColor: K.Colors.textFieldBlinkingBarColor))
//                .onSubmit {
//                    Task {
//                        let newText = searchText.replacingOccurrences(of: " ", with: "+")
//                        let coordinates = try await locationManager.getCoordinatesFromName(name: newText)
//                        let timezone = locationManager.timezoneForCoordinateInput
//                        await weatherViewModel.getWeather(latitude: coordinates.coordinate.latitude, longitude:coordinates.coordinate.longitude, timezone: timezone)
//
//                        appStateManager.searchedLocationDictionary["name"] = locationManager.currentLocationName
//                        appStateManager.searchedLocationDictionary["longitude"] = coordinates.coordinate.longitude
//                        appStateManager.searchedLocationDictionary["latitude"] = coordinates.coordinate.latitude
//                        appStateManager.searchedLocationDictionary["timezone"] = timezone
//
//
//                        appStateManager.searchedLocationDictionary["temperature"] = weatherViewModel.currentWeather.currentTemperature
//
//                        appStateManager.searchedLocationDictionary["date"] = weatherViewModel.currentWeather.date
//
//                        appStateManager.searchedLocationDictionary["symbol"] = weatherViewModel.currentWeather.symbol
//
//
//                        appStateManager.showSearchScreen = false
//
//                    }
//                }
            
            */
            
        }
    }
    
    
    //MARK: - Current Location
    var currentLocation: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weatherViewModel.localName)
                    .font(.headline)
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text("Your location")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack {
                HStack(alignment: .top, spacing: 0.0) {
                    Text(weatherViewModel.localTemp).font(.title)
                    Text(weatherViewModel.currentWeather.temperatureUnit)
                }
                .foregroundColor(.secondary)
                
                Image(systemName: WeatherManager.shared.getImage(imageName: weatherViewModel.localsfSymbol))
                    .renderingMode(.original)
            }
        }
        .padding(.bottom)
        .onTapGesture {
            Task {
                await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let timezone = locationManager.timezoneForCoordinateInput
                await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                let userLocationName = locationManager.currentLocationName
                await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
                
                
                
                appStateManager.searchedLocationDictionary["name"] = locationManager.currentLocationName
                appStateManager.searchedLocationDictionary["longitude"] = locationManager.longitude
                appStateManager.searchedLocationDictionary["latitude"] = locationManager.latitude
                appStateManager.searchedLocationDictionary["timezone"] = timezone
                
                appStateManager.showSearchScreen = false

//                persistenceLocations.saveData()
                

            }
        }
    }
}





struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingScreen()
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(WeatherViewModel())
            .environmentObject(CoreLocationViewModel())
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())
    }
}
