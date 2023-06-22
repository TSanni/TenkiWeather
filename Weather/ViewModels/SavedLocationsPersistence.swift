//
//  SavedLocationsPersistence.swift
//  Weather
//
//  Created by Tomas Sanni on 6/19/23.
//

import Foundation
import CoreData
import WeatherKit

class SavedLocationsPersistence: ObservableObject {
    
    let container: NSPersistentContainer

    @Published var savedLocations: [LocationEntity] = []
//    @Published var allWeather: [TodayWeatherModel] = []
    
    init() {
        container = NSPersistentContainer(name: "SavedLocations")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA \(error)")
            }
        }
        fetchLocations()
        
        Task {
            try await fetchWeatherPlacesWithTaskGroup()
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        
    }
    
    func fetchLocations() {
        let request = NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
        
        do {
            savedLocations = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching. \(error)")
        }
    }
    
    
    //TODO: Add a name paramter to this function which will be pass in from Google places
    func addFruit(lat: Double, lon: Double) {
        let newFruit = LocationEntity(context: container.viewContext)
        newFruit.name = "a"
        newFruit.latitude = lat
        newFruit.longitude = lon
        newFruit.timeAdded = Date.now
        saveData()
    }
    
    func updateFruit(entity: LocationEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedLocations[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchLocations()
            //TODO: This Task produces bug where only saved locations update and not main view. Perhaps remove this and find a way to update entirety of app
            Task {
                try await fetchWeatherPlacesWithTaskGroup()
            }

        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
    func fetchWeatherPlacesWithTaskGroup() async throws -> [LocationEntity]  {

        return try await withThrowingTaskGroup(of: LocationEntity?.self) { group in
            var weather: [LocationEntity] = []
//            weather.reserveCapacity(urlStrings.count)
            
            for location in savedLocations {
                group.addTask {
                    
                    try? await self.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude, entity: location)

                }
            }
            
            // Special For Loop. This For Loop waits for each task to come back
            // If a task never comes back, we would wait forever or until it fails
            for try await currentData in group {
                if let data = currentData {
                    weather.append(data)
                }
            }
            
//            savedLocationsCurrentWeather = weather
            
            let a = weather
            await MainActor.run(body: {
                self.savedLocations = a
            })
            
            return weather
        }
    }
    
    
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double, entity: LocationEntity) async throws -> LocationEntity {
        let currentAndTimezone = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude)
        
        if let current = currentAndTimezone.0 {
            let todaysWeather = WeatherManager.shared.getTodayWeather(current: current.currentWeather, dailyWeather: current.dailyForecast, hourlyWeather: current.hourlyForecast, timezoneOffset: currentAndTimezone.1)
            
            entity.currentDate = todaysWeather.date
            entity.temperature = todaysWeather.currentTemperature
            entity.sfSymbol = todaysWeather.symbol
            return entity
        } else {
            throw URLError(.badURL)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func fetchWeatherPlacesWithTaskGroup() async throws -> [TodayWeatherModel]  {
//
//        return try await withThrowingTaskGroup(of: TodayWeatherModel?.self) { group in
//            var weather: [TodayWeatherModel] = []
////            weather.reserveCapacity(urlStrings.count)
//
//            for location in savedLocations {
//                group.addTask {
//
//                    try? await self.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude)
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
//            let a = weather
//            await MainActor.run(body: {
//                self.allWeather = a
//            })
//
//            return weather
//        }
//    }
//
//
//
//
//
//    private func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> TodayWeatherModel {
//        let currentAndTimezone = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude)
////        let current = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
//
//        if let current = currentAndTimezone.0 {
//            let todaysWeather = WeatherManager.shared.getTodayWeather(current: current.currentWeather, dailyWeather: current.dailyForecast, hourlyWeather: current.hourlyForecast, timezoneOffset: currentAndTimezone.1)
//            //        let todaysWeather = await test.getTodayWeather(current: current.currentWeather, dailyWeather: current.dailyForecast, hourlyWeather: current.hourlyForecast)
//            print("THE DATE: \(todaysWeather.date)")
//            return todaysWeather
//        } else {
//            throw URLError(.badURL)
//        }
//    }

    
    
}
