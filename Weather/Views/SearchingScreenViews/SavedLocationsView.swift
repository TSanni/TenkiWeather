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
//                            persistence.updateFruit(entity: item)

                            await locationManager.getNameFromCoordinates(latitude: item.latitude, longitude: item.longitude)

                            await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
                            
                            locationManager.currentLocationName = item.name!
                            
                            appStateManager.searchedLocationDictionary["name"] = locationManager.currentLocationName
                            appStateManager.searchedLocationDictionary["longitude"] = item.longitude
                            appStateManager.searchedLocationDictionary["latitude"] = item.latitude
                            appStateManager.searchedLocationDictionary["timezone"] = item.timezone

                            appStateManager.showSearchScreen = false
                            
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
}

//struct SavedLocationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationsView()
////            .environmentObject(SavedLocationsPersistence())
//        
//    }
//}
