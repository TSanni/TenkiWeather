////
////  SavedLocationsPersistence.swift
////  Weather
////
////  Created by Tomas Sanni on 6/19/23.
////
//
//import Foundation
//import CoreData
////import WeatherKit
//import CoreLocation
//
//class SavedLocationsPersistence: ObservableObject {
//    
//    let container: NSPersistentContainer
//
//    @Published var savedLocations: [LocationEntity] = []
//    
//    init() {
//        container = NSPersistentContainer(name: "SavedLocations")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("ERROR LOADING CORE DATA \(error)")
//                return
//            }
//        }
//        fetchLocations()
//        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        
//
//        
//    }
//
//    func fetchLocations() {
//        
//        let request = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        Task {
//            do {
//                try await MainActor.run {
//                    savedLocations = try container.viewContext.fetch(request)
//
//                }
//    //            print("Sorted locations: \(savedLocations[0].name), \(savedLocations[1].name), \(savedLocations[2].name), \(savedLocations[3].name)")
//            } catch let error{
//                print("Error fetching. \(error)")
//            }
//        }
//
//    }
//    
//    //TODO: Add initial temperature and symbol
//    func addFruit(name: String, lat: Double, lon: Double, timezone: Int)  {
//        let newFruit = LocationEntity(context: container.viewContext)
//        newFruit.name = name
//        newFruit.latitude = lat
//        newFruit.longitude = lon
//        newFruit.timeAdded = Date.now
//        newFruit.timezone = Int16(timezone)
//        saveData()
//        
////        WeatherManager.shared.
//    }
//    
//    func updateFruit(entity: LocationEntity) {
//        let currentName = entity.name ?? ""
//        let newName = currentName + "!"
//        entity.name = newName
//        saveData()
//    }
//    
//    func deleteFruit(indexSet: IndexSet) {
//        guard let index = indexSet.first else { return }
//        let entity = savedLocations[index]
//        container.viewContext.delete(entity)
//        saveData()
//    }
//    
//    func saveData() {
//        do {
//            try container.viewContext.save()
//            //TODO: This Task produces bug where only saved locations update and not main view. Perhaps remove this and find a way to update entirety of app
//            Task {
//                try await fetchWeatherPlacesWithTaskGroup()
//                fetchLocations()
//            }
//
//        } catch let error {
//            print("Error saving. \(error)")
//        }
//    }
//    
//    
//    func fetchWeatherPlacesWithTaskGroup() async throws   {
//
//        return try await withThrowingTaskGroup(of: LocationEntity?.self) { group in
//            var weather: [LocationEntity] = []
//
//            for location in savedLocations {
//                group.addTask {
//
//                    try? await self.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude, entity: location, timezone: Int(location.timezone))
//
//                }
//            }
//
//            // Special For Loop. This For Loop waits for each task to come back
//            // If a task never comes back, we would wait forever or until it fails
//            for try await currentData in group {
//                if let data = currentData {
//                    weather.append(data)
//                }
//            }
//
////            savedLocationsCurrentWeather = weather
//
//           let a = weather
//            await MainActor.run {
//                self.savedLocations = a
//            }
//
////            return weather
//        }
//    }
//    
//    
//    
//    private func fetchCurrentWeather(latitude: Double, longitude: Double, entity: LocationEntity, timezone: Int) async throws -> LocationEntity {
//        
//        let timezone = await gettimezone(latitude: latitude, longitude: longitude)
//        
//        let weather = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude, timezone: timezone)
//
//
//
//
//        if let currentWeather = weather {
//            let todaysWeather = WeatherManager.shared.getTodayWeather(current: currentWeather.currentWeather, dailyWeather: currentWeather.dailyForecast, hourlyWeather: currentWeather.hourlyForecast, timezoneOffset: timezone)
//
//            entity.currentDate = todaysWeather.date
//            entity.temperature = todaysWeather.currentTemperature
//            entity.sfSymbol = todaysWeather.symbol
//            return entity
//        } else {
//            throw URLError(.badURL)
//        }
//
//    }
//    
//    
//    
//    
//    private func gettimezone(latitude: Double, longitude: Double) async -> Int {
//        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
//        let geocoder = CLGeocoder()
//        
//        return await withCheckedContinuation { continuation in
//            geocoder.reverseGeocodeLocation(coordinates) { places, error in
//                
//                if error != nil { return }
//                
//                if let locations = places {
//                    print("CLPlacemark returned is: \(locations[0]) ")
//                    
//                    
//                    let timezone7 = locations[0].timeZone?.secondsFromGMT()
//                    continuation.resume(returning: timezone7 ?? 0)
//
//                } else {
//                    fatalError("Unable to get location. Check getNameFromCoordinates function")
//                }
//
//            }
//        }
//
//    }
//    
//}




import Foundation
import CoreData

class PersistenceController: ObservableObject {
    let container = NSPersistentContainer(name: "SavedLocations")
    
    init() {
        container.loadPersistentStores { description, error in
            if let e = error {
                print("There was an error loading core data: \(e.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
