//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI
import GooglePlaces

struct SearchingScreen: View {
    @State private var showGoogleSearchScreen: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var persistenceLocations: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager
    
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            VStack {
                CurrentLocationView(localWeather: weatherViewModel.localWeather)
                    .padding(.bottom)
                    .padding(.bottom)
                    .onTapGesture {
                        Task {
                            appStateManager.showSearchScreen = false
                            appStateManager.dataIsLoading()
                            await getWeatherAndUpdateDictionary()
                            persistenceLocations.saveData()
                            appStateManager.dataCompletedLoading()
                            appStateManager.performViewReset()
                            
                            
                        }
                    }
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                    Spacer()
                }
                
                CustomDivider()
                
                SavedLocationsView()
            }
            .padding()
        }
        .foregroundStyle(.white)
        .contentShape(Rectangle())
        .background(K.Colors.goodDarkTheme)
        .sheet(isPresented: $showGoogleSearchScreen) {
            PlacesViewControllerBridge { place in
                Task {
                    appStateManager.dataIsLoading()
                    
                    await getWeatherWithGoogleData(place: place)
                    persistenceLocations.saveData()
                    
                    appStateManager.dataCompletedLoading()
                    appStateManager.showSearchScreen = false
                    appStateManager.performViewReset()
                }
                
            }
        }
        
    }
    
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
                appStateManager.showSearchScreen = false
            } label: {
                Image(systemName: "arrow.left")
                //                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .padding()
            }
            
            Text("Search for a location")
                .frame(maxWidth: .infinity, alignment: .leading)
            //                .foregroundColor(.secondary)
                .onTapGesture {
                    showGoogleSearchScreen = true
                }
            
        }
    }
    
    
    //MARK: - Current Location
//    var currentLocation: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                
//                if locationManager.localLocationName == "" {
//                    Text("Tap to reload")
//                        .font(.headline)
//                    
//                } else {
//                    Text(locationManager.localLocationName)
//                        .font(.headline)
//                }
//                HStack {
//                    Image(systemName: "location.fill")
//                        .foregroundColor(.blue)
//                    Text("Your location")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//            
//            Spacer()
//            
//            HStack {
//                HStack(alignment: .top, spacing: 0.0) {
//                    Text(weatherViewModel.localTemp).font(.title)
//                    Text(weatherViewModel.currentWeather.temperatureUnit)
//                }
//                .foregroundColor(.secondary)
//                
//                Image(systemName: WeatherManager.shared.getImage(imageName: weatherViewModel.localsfSymbol))
//                    .renderingMode(.original)
//            }
//        }
//        .padding(.bottom)
//        .onTapGesture {
//            Task {
//                appStateManager.showSearchScreen = false
//                appStateManager.dataIsLoading()
//                await getWeatherAndUpdateDictionary()
//                persistenceLocations.saveData()
//                appStateManager.dataCompletedLoading()
//                appStateManager.performViewReset()
//                
//                
//            }
//        }
//    }
    
    
    
    private func getWeatherAndUpdateDictionary() async {
        
        await locationManager.getLocalLocationName()
        //        await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        locationManager.searchedLocationName = userLocationName
        
        appStateManager.setCurrentLocationName(name: userLocationName)
        appStateManager.searchedLocationDictionary["name"] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary["longitude"] = locationManager.longitude
        appStateManager.searchedLocationDictionary["latitude"] = locationManager.latitude
        appStateManager.searchedLocationDictionary["timezone"] = timezone
    }
    
    
    private func getWeatherWithGoogleData(place: GMSPlace) async {
        let coordinates = place.coordinate
        await locationManager.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, nameFromGoogle: place.name)
        //        let name = await locationManager.getNameFromCoordinates(latitude: coordinates.latitude, longitude: coordinates.longitude, nameFromGoogleAPI: place.name)
        let timezone = locationManager.timezoneForCoordinateInput
        
        await weatherViewModel.getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
        
        
        appStateManager.setSearchedLocationDictionary(
            name: locationManager.searchedLocationName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: timezone,
            temperature: weatherViewModel.currentWeather.currentTemperature,
            date: weatherViewModel.currentWeather.readableDate,
            symbol: weatherViewModel.currentWeather.symbolName,
            weatherCondition: weatherViewModel.currentWeather.weatherDescription.description
        )
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
