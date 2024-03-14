//
//  SavedLocationsPersistenceViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/19/23.
//

import Foundation
import CoreData

//TODO: Add a new version of the data model. You can't edit the xcdatamodel and expect Core Data to just use the new version. You need to keep your existing model, create a new version, and make your changes in the new version. You must always have a version of the model that matches the persistent store file.
class SavedLocationsPersistenceViewModel: ObservableObject {
    static let shared = SavedLocationsPersistenceViewModel()

    let container: NSPersistentContainer
    let weatherManager = WeatherManager.shared
    
    @Published var savedLocations: [Location] = []
    
    private init() {
        
        ValueTransformer.setValueTransformer(UnitTemperatureTransformer(), forName: NSValueTransformerName("UnitTemperatureTransformer"))
        
        container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA \(error)")
                return
            }
        }
        fetchLocations()
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    func fetchLocations() {        
        let request = NSFetchRequest<Location>(entityName: "Location")
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
    
    func addLocation(locationDictionary: [String: Any])  {

        guard let time = locationDictionary[K.LocationDictionaryKeysConstants.timezone] as? Int else {
            print("COULD NOT CONVERT")
            return
        }
        
        let newLocation = Location(context: container.viewContext)
        
        newLocation.name = locationDictionary[K.LocationDictionaryKeysConstants.name] as? String
        newLocation.latitude = locationDictionary[K.LocationDictionaryKeysConstants.latitude] as? Double ?? 0
        newLocation.longitude = locationDictionary[K.LocationDictionaryKeysConstants.longitude] as? Double ?? 0
        newLocation.timeAdded = Date.now
        newLocation.timezone = Double(time)
        newLocation.temperature = locationDictionary[K.LocationDictionaryKeysConstants.temperature] as? String
        newLocation.currentDate = locationDictionary[K.LocationDictionaryKeysConstants.date] as? String
        newLocation.sfSymbol = locationDictionary[K.LocationDictionaryKeysConstants.symbol] as? String
        newLocation.weatherCondition = locationDictionary[K.LocationDictionaryKeysConstants.weatherCondition] as? String
        newLocation.unitTemperature = locationDictionary[K.LocationDictionaryKeysConstants.unitTemperature] as? UnitTemperature 
        
        Task {
            try await fetchWeatherPlacesWithTaskGroup()
            saveData()
        }
        
    }
    
    
    func updatePlaceName(entity: Location, newName: String) {
        if newName == "" {
            return
        }
        let newName = newName
        entity.name = newName
        saveData()
    }
    
//    func updatePlace(entity: LocationEntity) {
//        let currentName = entity.name ?? ""
//        let newName = currentName + "!"
//        entity.name = newName
//        saveData()
//    }
    
    func deletePlace(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedLocations[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func deleteLocationFromContextMenu(entity: Location) {
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
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
        
        return try await withThrowingTaskGroup(of: Location?.self) { group in
            var weather: [Location] = []

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
    
    private func fetchCurrentWeather(entity: Location) async throws -> Location {
        
        let weather = try await weatherManager.getWeatherFromWeatherKit(latitude: entity.latitude, longitude: entity.longitude, timezone: Int(entity.timezone))

        if let currentWeather = weather {
            let todaysWeather = await weatherManager.getTodayWeather(
                current: currentWeather.currentWeather,
                dailyWeather: currentWeather.dailyForecast,
                hourlyWeather: currentWeather.hourlyForecast,
                timezoneOffset: Int(entity.timezone)
            )
            
            let possibleWeatherAlerts = await weatherManager.getWeatherAlert(optionalWeatherAlert: currentWeather.weatherAlerts)
          
            entity.currentDate = todaysWeather.readableDate
            entity.temperature = todaysWeather.currentTemperature
            entity.sfSymbol = todaysWeather.symbolName
            entity.weatherCondition = todaysWeather.weatherDescription.description
            entity.unitTemperature = Helper.getUnitTemperature()
            
            if possibleWeatherAlerts != nil {
                entity.weatherAlert = true
            } else {
                entity.weatherAlert = false
            }
            
            return entity
        } else {
            throw URLError(.badURL)
        }
    }
}
