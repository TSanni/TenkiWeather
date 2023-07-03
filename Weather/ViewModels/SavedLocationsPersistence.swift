//
//  SavedLocationsPersistence.swift
//  Weather
//
//  Created by Tomas Sanni on 6/19/23.
//

import Foundation
import CoreData

class SavedLocationsPersistence: ObservableObject {
    
    let container: NSPersistentContainer

    @Published var savedLocations: [LocationEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "SavedLocations")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA \(error)")
                return
            }
        }
        print(" \n SavedLocationsPersistence initialized!! \n")
        fetchLocations()
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        
    }

    func fetchLocations() {
        print(" \n fetchLocations method called! \n")
        
        let request = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "timeAdded", ascending: false)]
        Task {
            do {
                try await fetchWeatherPlacesWithTaskGroup()
                try await MainActor.run {
                    savedLocations = try container.viewContext.fetch(request)
                }
            } catch let error{
                print("Error fetching. \(error)")
            }
        }

    }
    
    //TODO: Add initial temperature and symbol
    func addLocation(locationDictionary: [String: Any])  {
        
        print(" \n addLocation method called \n")

        guard let time = locationDictionary["timezone"] as? Int else {
            print("COULD NOT CONVERT")
            return
        }
        
        let newLocation = LocationEntity(context: container.viewContext)
        
        newLocation.name = locationDictionary["name"] as? String
        newLocation.latitude = locationDictionary["latitude"] as? Double ?? 0
        newLocation.longitude = locationDictionary["longitude"] as? Double ?? 0
        newLocation.timeAdded = Date.now
        newLocation.timezone = Double(time)
        
        
        newLocation.temperature = locationDictionary["temperature"] as? String
        newLocation.currentDate = locationDictionary["date"] as? String
        newLocation.sfSymbol = locationDictionary["symbol"] as? String
        
        
        Task {
            try await fetchWeatherPlacesWithTaskGroup()
            saveData()
        }
        
    }
    
//    func updatePlace(entity: LocationEntity) {
//        let currentName = entity.name ?? ""
//        let newName = currentName + "!"
//        entity.name = newName
//        saveData()
//    }
    
    func deletePlace(indexSet: IndexSet) {
        print(" \n deletePlace method called! \n ")
        guard let index = indexSet.first else { return }
        let entity = savedLocations[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        print(" \n saveData method called! \n")
        do {
            Task {
                try await fetchWeatherPlacesWithTaskGroup()
                fetchLocations()
            }
            
            
            try container.viewContext.save()

        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
    func fetchWeatherPlacesWithTaskGroup() async throws   {
        print(" \n fetchWeatherPlacesWithTaskGroup method called! \n")
        
        return try await withThrowingTaskGroup(of: LocationEntity?.self) { group in
            var weather: [LocationEntity] = []

            for location in savedLocations {
                group.addTask {

                    try? await self.fetchCurrentWeather(entity: location)

                }
            }

            // Special For Loop. This For Loop waits for each task to come back
            // If a task never comes back, we would wait forever or until it fails
            for try await currentData in group {
                if let data = currentData {
                    weather.append(data)
                }
            }
        }
    }
    
    
    
    
    
    
    private func fetchCurrentWeather(entity: LocationEntity) async throws -> LocationEntity {
        print(" \n fetchCurrentWeather method called! \n")
        
        
        let weather = try await WeatherManager.shared.getWeather(latitude: entity.latitude, longitude: entity.longitude, timezone: Int(entity.timezone))



        if let currentWeather = weather {
            let todaysWeather = WeatherManager.shared.getTodayWeather(current: currentWeather.currentWeather, dailyWeather: currentWeather.dailyForecast, hourlyWeather: currentWeather.hourlyForecast, timezoneOffset: Int(entity.timezone))
          

            entity.currentDate = todaysWeather.date
            entity.temperature = todaysWeather.currentTemperature
            entity.sfSymbol = todaysWeather.symbol
            return entity
        } else {
            throw URLError(.badURL)
        }

    }
    
}
