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
    @Published var allWeather: [TodayWeatherModel] = []
    
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
    
    func addFruit(text: String) {
        let newFruit = LocationEntity(context: container.viewContext)
        newFruit.name = text
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
            Task {
                try await fetchWeatherPlacesWithTaskGroup()
            }

        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    
    func fetchWeatherPlacesWithTaskGroup() async throws -> [TodayWeatherModel]  {

        return try await withThrowingTaskGroup(of: TodayWeatherModel?.self) { group in
            var weather: [TodayWeatherModel] = []
//            weather.reserveCapacity(urlStrings.count)
            
            for location in savedLocations {
                group.addTask {

                    try? await self.fetchCurrentWeather(latitude: location.latitude, longitude: location.longitude)

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
                self.allWeather = a
            })
            
            return weather
        }
    }
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> TodayWeatherModel {
        
        let current = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
        
        let todaysWeather = WeatherManager.shared.getTodayWeather(current: current.currentWeather, dailyWeather: current.dailyForecast, hourlyWeather: current.hourlyForecast)
//        let todaysWeather = await test.getTodayWeather(current: current.currentWeather, dailyWeather: current.dailyForecast, hourlyWeather: current.hourlyForecast)

        return todaysWeather
    }

    
    
}
