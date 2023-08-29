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
            }
            ForEach(persistence.savedLocations, id: \.self) { item in
                SavedLocationCell(location: item)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        Task {
                            appStateManager.showSearchScreen = false
                            appStateManager.dataIsLoading()
                            await getWeatherAndUpdateDictionary(item: item)
                            appStateManager.dataCompletedLoading()
                            appStateManager.scrollToTopAndChangeTabToToday()
                            persistence.saveData()
                            
                        }
                    }                
            }
            .onDelete(perform: persistence.deletePlace(indexSet:))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
    
    
    private func getWeatherAndUpdateDictionary(item: LocationEntity) async {
        await locationManager.getLocalLocationName()
        await locationManager.getSearchedLocationName(lat: item.latitude, lon: item.longitude, nameFromGoogle: nil)
//        let name = await locationManager.getNameFromCoordinates(latitude: item.latitude, longitude: item.longitude)
        await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
        await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: locationManager.localLocationName, timezone: appStateManager.currentLocationTimezone)
        print("\n\n")
        print("LOCAL NAME: \(weatherViewModel.localName)")
        print("LOCAL TEMP: \(weatherViewModel.localTemp)")
        print("\n\n")

        locationManager.searchedLocationName = item.name!
        
        appStateManager.searchedLocationDictionary["name"] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary["longitude"] = item.longitude
        appStateManager.searchedLocationDictionary["latitude"] = item.latitude
        appStateManager.searchedLocationDictionary["timezone"] = item.timezone
    }

}

//struct SavedLocationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationsView()
////            .environmentObject(SavedLocationsPersistence())
//        
//    }
//}
