//
//  SavedLocationsPersistenceViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/19/23.
//

import Foundation
import CoreData

class SavedLocationsPersistenceViewModel: ObservableObject {
    private let weatherManager: WeatherServiceProtocol
    private let coreLocationModel: CoreLocationViewModelProtocol
    private let container: NSPersistentContainer
    private let timezoneMigrationFlagKey = K.UserDefaultKeys.migrationFlagKey

    @Published private(set) var savedLocations: [Location] = []
    @Published var showErrorAlert = false
    @Published var currentError: CoreDataErrors? = nil
    
    init(weatherManager: WeatherServiceProtocol, coreLocationModel: CoreLocationViewModelProtocol) {
        print(#function)
        self.weatherManager = weatherManager
        self.coreLocationModel = coreLocationModel
        container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores { description, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.currentError = .failedToLoad
                }
                print("❌ ERROR LOADING CORE DATA \(error)")
                return
            }
        }
        fetchAllLocations(updateNetwork: true)

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    
    private func migrateTimezoneDataIfNeeded() {
        print(#function)
        let hasMigrated = UserDefaults.standard.bool(forKey: timezoneMigrationFlagKey)
        guard !hasMigrated else {
            print("✅ Timezone migration already done.")
            return
        }

        print("--- MIGRATING DATA ---")
        
        Task {
            for location in savedLocations {
                if location.timezoneIdentifier != nil { continue }

                if let placeData = await coreLocationModel.getPlaceDataFromCoordinates(latitude: location.latitude, longitude: location.longitude),
                   let tz = placeData.timeZone {
                    await MainActor.run {
                        location.timezoneIdentifier = tz.identifier
                    }
                }
            }

            await MainActor.run {
                self.saveData()
                UserDefaults.standard.set(true, forKey: self.timezoneMigrationFlagKey)
                print("✅ Timezone migration completed and flag set.")
            }
        }
    }
    
    func createLocation(locationInfo: SearchLocationModel) throws {
        if savedLocations.count >= 20 {
            throw CoreDataErrors.locationSaveLimitReached
        }
        
        let newLocation = Location(context: container.viewContext)
        
        // Get the maximum order directly from Core Data
        let maxOrder = getMaxOrder()
        print("MAX ORDER: \(maxOrder)")
        
        newLocation.name = locationInfo.name
        newLocation.order = Int64(maxOrder + 1)
        newLocation.latitude = locationInfo.latitude
        newLocation.longitude = locationInfo.longitude
        newLocation.timeAdded = Date.now
        newLocation.timezoneIdentifier = locationInfo.timeZoneIdentifier
        newLocation.temperature = locationInfo.temperature
        newLocation.currentDate = locationInfo.date
        newLocation.sfSymbol = locationInfo.symbol
        newLocation.weatherCondition = locationInfo.weatherCondition
        newLocation.weatherAlert = locationInfo.weatherAlert
        newLocation.timezone = Double(locationInfo.timezone)
        
        saveData()
        fetchAllLocations(updateNetwork: true)
    }
    
    private func getMaxOrder() -> Int32 {
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let result = try container.viewContext.fetch(request)
            return Int32(result.first?.order ?? 0)
        } catch {
            print("Failed to fetch max order: \(error)")
            return 0
        }
    }
    
    func updateLocationName(entity: Location, newName: String) {
        if newName.isEmpty || newName == entity.name {
            print("Either newName is empty or is identical to saved location name")
            return
        }
        
        entity.name = newName
        saveData()
        fetchAllLocations(updateNetwork: false)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = savedLocations
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in updatedItems.enumerated() {
            item.order = Int64(index)
        }
        
        saveData()
        fetchAllLocations(updateNetwork: false)
    }
    
    func deleteLocationBySwipe(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let location = savedLocations[index]
        container.viewContext.delete(location)
        saveData()
        fetchAllLocations(updateNetwork: false)
    }
    
    func deleteLocationFromContextMenu(location: Location) {
        container.viewContext.delete(location)
        saveData()
        fetchAllLocations(updateNetwork: false)
    }
    
    private func saveData() {
        print(#function)
        
        do {
            try container.viewContext.save()
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert.toggle()
                self.currentError = .failedToSave
            }
        }
    }
    
     func fetchAllLocations(updateNetwork: Bool) {
        print(#function)
        
        let ascending = UserDefaults.standard.bool(forKey: "ascendOrDescend")
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: ascending)]
        
        do {
            let fetchedLocation = try container.viewContext.fetch(request)
            DispatchQueue.main.async {
                self.savedLocations = fetchedLocation
                self.migrateTimezoneDataIfNeeded()

                if updateNetwork {
                    print("🛜 updating network")
                    Task(priority: .background) {
                        await self.callFetchWeatherPlacesWithTaskGroup()
                    }
                }
                
            }
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert.toggle()
                self.currentError = .failedToFetch
            }
        }
    }
    
    func callFetchWeatherPlacesWithTaskGroup() async {
        print(#function)
        
        if savedLocations.isEmpty {
            print("No saved data.")
            return
        }
        
        do {
            let updatedLocations = try await fetchWeatherPlacesWithTaskGroup(allLocation: savedLocations)
            await MainActor.run {
                self.savedLocations = updatedLocations
            }
            
            fetchAllLocations(updateNetwork: false)
        } catch {
            await MainActor.run {
                self.showErrorAlert.toggle()
                self.currentError = .failedToFetch
            }
        }
    }
    
    private func fetchWeatherPlacesWithTaskGroup(allLocation: [Location]) async throws -> [Location] {
        print(#function)
        
        return try await withThrowingTaskGroup(of: Location?.self) { group in
            var weather: [Location] = []
            
            for location in allLocation {
                group.addTask {
                    try await self.fetchCurrentWeather(entity: location)
                }
            }
            
            // Special For Loop. This For Loop waits for each task to come back
            // If a task never comes back, we would wait forever or until it fails
            for try await currentData in group {
                if let data = currentData {
                    weather.append(data)
                }
            }
            
            return weather
        }
    }
    
    private func fetchCurrentWeather(entity: Location) async throws -> Location {
        do {
            let currentWeather = try await weatherManager.fetchWeatherFromWeatherKit(latitude: entity.latitude, longitude: entity.longitude, timezoneIdentifier: entity.timezoneIdentifier ?? K.defaultTimezoneIdentifier)
            
            let todaysWeather = weatherManager.getTodayWeather(
                current: currentWeather.currentWeather,
                dailyWeather: currentWeather.dailyForecast,
                hourlyWeather: currentWeather.hourlyForecast,
                timezoneIdentifier: entity.timezoneIdentifier ?? K.defaultTimezoneIdentifier
            )
            
            let possibleWeatherAlerts = weatherManager.getWeatherAlert(optionalWeatherAlert: currentWeather.weatherAlerts)
            
            await MainActor.run {
                entity.currentDate = todaysWeather.readableDate
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
        } catch {
            throw CoreDataErrors.failedToFetchCurrentWeather
        }
    }
}
