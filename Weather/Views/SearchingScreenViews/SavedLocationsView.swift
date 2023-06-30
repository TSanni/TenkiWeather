//
//  SavedLocationsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI
import CoreData

struct SavedLocationsView: View {
//    let todayCollection: [LocationEntity]
//    @EnvironmentObject var vm: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)], animation: .easeInOut) var places: FetchedResults<LocationEntity>
    
//    @Environment(\.managedObjectContext) var moc
//    @ObservedObject var places: LocationEntity
    var places: FetchedResults<LocationEntity>
    let testMOC: NSManagedObjectContext

    var body: some View {
        List {
            if places.count == 0 {
                Text("")
                    .listRowBackground(Color.clear)
            }
            ForEach(places, id: \.self) { item in
                SavedLocationCell(location: item)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)

                    .onTapGesture {
                        Task {
//                            self.locationManager.objectWillChange.send()
//                            vm.updateFruit(entity: item)
                            item.name = (item.name ?? "") + "!"
                            try testMOC.save()
                            await locationManager.getNameFromCoordinates(latitude: item.latitude, longitude: item.longitude)

                            await weatherViewModel.getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
                            
                            appStateManager.searchedLocationDictionary["name"] = locationManager.currentLocationName
                            appStateManager.searchedLocationDictionary["longitude"] = item.longitude
                            appStateManager.searchedLocationDictionary["latitude"] = item.latitude
                            
//                            appStateManager.showSearchScreen = false

//                            vm.saveData()
//                            print("DATE IN SAVED LOCATION: \(item.currentDate)")

                        }
                    }
                
                
            }
            .onDelete(perform: deletePlace(at:))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func addLocation() {
//        let addedCity = Place(context: moc)
//        //dont need all this for core data
//        //need to only store coordinates in core data
//        addedCity.timeAdded = Date.now
//        addedCity.name = weather.userLocation
//        addedCity.date = weather.currentWeather.currentTime
//        addedCity.date = weather.dateForCoreData
//        addedCity.longitude = weather.lonForCoreData
//        addedCity.latitude = weather.latForCoreData
//
//        try? moc.save()
//        print("The coordinates saved to core data: Lat: \(addedCity.wrappedLatitude) Lon: \(addedCity.wrappedLongitude)")
//    }
    
    
    func deletePlace(at offsets: IndexSet) {
        for offset in offsets {
            let place = places[offset]
            testMOC.delete(place)
            
        }
        try? testMOC.save()
        
    }
    
    
    
    
    
}

//struct SavedLocationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationsView()
////            .environmentObject(SavedLocationsPersistence())
//        
//    }
//}
