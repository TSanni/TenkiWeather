//
//  SavedLocationsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationsView: View {
    @EnvironmentObject var persistence: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager

    

    var body: some View {
        List {
            if persistence.savedLocations.count == 0 {
                Text("")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            ForEach(persistence.savedLocations, id: \.self) { item in
                SavedLocationCell(location: item)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.top)
                    .onTapGesture {
                        Task {
                            appStateManager.showSearchScreen = false
                            appStateManager.dataIsLoading()
                            await getWeatherAndUpdateDictionary(item: item)
                            appStateManager.dataCompletedLoading()
                            appStateManager.performViewReset()
                            persistence.saveData()
                        }
                    }
            }
            .onDelete(perform: persistence.deletePlace(indexSet:))

            

        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
    
    
    private func getWeatherAndUpdateDictionary(item: LocationEntity) async {
        await locationManager.getLocalLocationName()
        await locationManager.getSearchedLocationName(lat: item.latitude, lon: item.longitude, nameFromGoogle: nil)
        await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: locationManager.localLocationName, timezone: appStateManager.currentLocationTimezone)
        

        locationManager.searchedLocationName = item.name!
        
        
        
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.name] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.longitude] = item.longitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.latitude] = item.latitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.timezone] = item.timezone
    }

}

struct SavedLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationsView()
            .environmentObject(SavedLocationsPersistence())
        
    }
}
