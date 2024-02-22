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
                            appStateManager.toggleShowSearchScreen()
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
                    
                    await weatherViewModel.getWeatherWithGoogleData(place: place)
                    persistenceLocations.saveData()
                    
                    appStateManager.dataCompletedLoading()
                    appStateManager.toggleShowSearchScreen()
                    appStateManager.performViewReset()
                }
                
            }
        }
    }
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
                appStateManager.toggleShowSearchScreen()
            } label: {
                Image(systemName: "arrow.left")
                    .contentShape(Rectangle())
                    .padding()
            }
            
            Text("Search for a location")
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    DispatchQueue.main.async {
                        showGoogleSearchScreen = true
                    }
                }
        }
    }
    
    private func getWeatherAndUpdateDictionary() async {
        
        await locationManager.getLocalLocationName()
        let timezone = locationManager.timezoneForCoordinateInput
        await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        locationManager.searchedLocationName = userLocationName
        
        appStateManager.setCurrentLocationName(name: userLocationName)
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.name] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.latitude] = locationManager.latitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.longitude] = locationManager.longitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.timezone] = timezone
    }
}


struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingScreen()
            .environmentObject(WeatherViewModel.shared)
            .environmentObject(CoreLocationViewModel.shared)
            .environmentObject(AppStateManager.shared)
            .environmentObject(SavedLocationsPersistence.shared)
    }
}
