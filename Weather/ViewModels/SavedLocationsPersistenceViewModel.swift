//
//  SavedLocationsPersistenceViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/19/23.
//

import Foundation
import CoreData

class SavedLocationsPersistenceViewModel: ObservableObject {
    static let shared = SavedLocationsPersistenceViewModel()
    let weatherManager = WeatherManager.shared

    let container: NSPersistentContainer

    @Published private(set) var savedLocations: [Location] = []
    @Published var showErrorAlert = false
    @Published var currentError: CoreDataErrors? = nil
    
    private init() {
        UserDefaults.standard.set("timeAdded", forKey: "sortType")
        UserDefaults.standard.set(false, forKey: "ascending")

        
        container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores { description, error in
            if let error = error {
                self.currentError = .failedToLoad
                print("ERROR LOADING CORE DATA \(error)")
                return
            }
        }
        fetchLocations()
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func fetchLocationsWithUserDeterminedOrder(key: String, ascending: Bool) {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        
        Task {
            do {
                try await MainActor.run {
                    savedLocations = try container.viewContext.fetch(request)
                }
            } catch {
                await MainActor.run {
                    showErrorAlert.toggle()
                    currentError = .failedToFetch

                }
            }

        }
    }

    private func fetchLocations() {
        let key = UserDefaults.standard.string(forKey: "sortType")
        let ascending = UserDefaults.standard.bool(forKey: "ascending")

        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        Task {
            do {
                try await fetchWeatherPlacesWithTaskGroup()
                try await MainActor.run {
                    savedLocations = try container.viewContext.fetch(request)
                }
            } catch {
                await MainActor.run {
                    showErrorAlert.toggle()
                    currentError = .failedToFetch
                }

            }
        }
    }
    
    private func fetchLocationsAfterDelete() {
        let key = UserDefaults.standard.string(forKey: "sortType")
        let ascending = UserDefaults.standard.bool(forKey: "ascending")

        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        Task {
            do {
                try await MainActor.run {
                    savedLocations = try container.viewContext.fetch(request)
                }
            } catch {
                await MainActor.run {
                    showErrorAlert.toggle()
                    currentError = .failedToFetch
                }
            }
        }
    }
    
    func addLocation(locationDictionary: SearchLocationModel)  {

        let newLocation = Location(context: container.viewContext)
        
        newLocation.name = locationDictionary.name
        newLocation.latitude = locationDictionary.latitude
        newLocation.longitude = locationDictionary.longitude
        newLocation.timeAdded = Date.now
        newLocation.timezone = Double(locationDictionary.timezone)
        newLocation.temperature = locationDictionary.temperature
        newLocation.currentDate = locationDictionary.date
        newLocation.sfSymbol = locationDictionary.symbol
        newLocation.weatherCondition = locationDictionary.weatherCondition
        newLocation.weatherAlert = locationDictionary.weatherAlert
        
        Task {
            try await fetchWeatherPlacesWithTaskGroup()
            saveData()
        }
        
    }
    
    func updatePlaceName(entity: Location, newName: String) {
        let key = UserDefaults.standard.string(forKey: "sortType")
        let ascending = UserDefaults.standard.bool(forKey: "ascending")

        if newName == "" {
            return
        }
        let newName = newName
        entity.name = newName
        fetchLocationsWithUserDeterminedOrder(key: key ?? "name", ascending: ascending)
        saveData()
    }
    
    func deletePlace(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedLocations[index]
        container.viewContext.delete(entity)
        saveDataAfterDelete()
    }
    
    func deleteLocationFromContextMenu(entity: Location) {
        container.viewContext.delete(entity)
        saveDataAfterDelete()
    }
    
    func saveData() {
            do {
                try container.viewContext.save()
                
                fetchLocations()
                Task {
                    try await fetchWeatherPlacesWithTaskGroup()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert.toggle()
                    self.currentError = .failedToSave
                }
            }
    }
    
    func saveDataAfterDelete() {
            do {
                try container.viewContext.save()
                fetchLocationsAfterDelete()
                
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert.toggle()
                    self.currentError = .failedToSave
                }

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
            
            DispatchQueue.main.async {
                //TODO: An error happened in this line. FIX
                entity.currentDate = todaysWeather.readableDate // ERROR HERE
                entity.temperature = todaysWeather.temperature.value.description
                entity.sfSymbol = todaysWeather.symbolName
                entity.weatherCondition = todaysWeather.weatherDescription
                
                if possibleWeatherAlerts != nil {
                    entity.weatherAlert = true
                } else {
                    entity.weatherAlert = false
                }
            }
            
            
            
            return entity
        } else {
            throw CoreDataErrors.failedToFetchCurrentWeather
        }
    }
}
