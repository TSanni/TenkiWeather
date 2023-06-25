//
//  SavedLocationsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationsView: View {
    let todayCollection: [LocationEntity]
    @EnvironmentObject var vm: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
//    @EnvironmentObject var geoViewModel: GeocodingViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel


    var body: some View {
        List {
            if todayCollection.count == 0 {
                Text("")
                    .listRowBackground(Color.clear)
            }
            ForEach(vm.savedLocations) { item in
                SavedLocationCell(location: item)
                   // .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        Task {
                            await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude)
                            await locationManager.getNameFromCoordinates(latitude: item.latitude, longitude: item.longitude)
//                            await geoViewModel.getReverseGeoData(lat: item.latitude, lon: item.longitude)

                            vm.saveData()
                            print("DATE IN SAVED LOCATION: \(item.currentDate)")

                        }
                    }
                
                
            }
            .onDelete(perform: vm.deleteFruit(indexSet:))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct SavedLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationsView(todayCollection: [])
            .environmentObject(SavedLocationsPersistence())
        
    }
}
