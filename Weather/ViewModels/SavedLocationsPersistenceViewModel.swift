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
        container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores { description, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.currentError = .failedToLoad
                }
                print("ERROR LOADING CORE DATA \(error)")
                return
            }
        }
        fetchAllLocations(updateNetwork: true)

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    
    func createLocation(locationInfo: SearchLocationModel) {
        let newLocation = Location(context: container.viewContext)
        
        newLocation.name = locationInfo.name
        newLocation.order = (savedLocations.last?.order ?? 0) + 1
        newLocation.latitude = locationInfo.latitude
        newLocation.longitude = locationInfo.longitude
        newLocation.timeAdded = Date.now
        newLocation.timezone = Double(locationInfo.timezone)
        newLocation.temperature = locationInfo.temperature
        newLocation.currentDate = locationInfo.date
        newLocation.sfSymbol = locationInfo.symbol
        newLocation.weatherCondition = locationInfo.weatherCondition
        newLocation.weatherAlert = locationInfo.weatherAlert
        
        saveData()
        fetchAllLocations(updateNetwork: true)
    }
    
    func updateLocationName(entity: Location, newName: String) {
        if newName.isEmpty {
            return
        }
        
        let newName = newName
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

        let key = UserDefaults.standard.string(forKey: "sortType")
        let ascending = UserDefaults.standard.bool(forKey: "ascending")
        let request = NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        do {
            let fetchedLocation = try container.viewContext.fetch(request)
            DispatchQueue.main.async {
                self.savedLocations = fetchedLocation
                
                if updateNetwork {
                    print("updating network")
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
            let a = try await fetchWeatherPlacesWithTaskGroup(allLocation: savedLocations)
            DispatchQueue.main.async {
                self.savedLocations = a
                self.saveData()
            }
            
            fetchAllLocations(updateNetwork: false)
        } catch {
            DispatchQueue.main.async {
                self.showErrorAlert.toggle()
                self.currentError = .failedToFetch
            }
        }
    }
    
    private func fetchWeatherPlacesWithTaskGroup(allLocation: [Location]) async throws -> [Location] {
        print(#function)

        return try await withThrowingTaskGroup(of: Location?.self) { group in
            var weather: [Location] = []
            
            for location in savedLocations {
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
        } else {
            throw CoreDataErrors.failedToFetchCurrentWeather
        }
    }
}
