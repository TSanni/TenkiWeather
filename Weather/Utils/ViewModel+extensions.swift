//
//  WeatherViewModel+extension.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/2/25.
//

import Foundation

//TODO: Replace WeatherManager() with a mock Weather Manager for previews

extension AppStateViewModel {
    static var preview: AppStateViewModel {
        let weatherManager = WeatherManager()
        let vm = AppStateViewModel(
            locationViewModel: CoreLocationViewModel(),
            weatherViewModel: WeatherViewModel(weatherManager: weatherManager),
            persistence: SavedLocationsPersistenceViewModel(weatherManager: weatherManager)
        )
        
        return vm
    }
}

extension WeatherViewModel {
    static var preview: WeatherViewModel {
        let weatherManager = WeatherManager()
        let vm = WeatherViewModel(weatherManager: weatherManager)
        
        return vm
    }
}

extension CoreLocationViewModel {
    static var preview: CoreLocationViewModel {
        let vm = CoreLocationViewModel()
        
        return vm
    }
}

extension SavedLocationsPersistenceViewModel {
    static var preview: SavedLocationsPersistenceViewModel {
        let weatherManager = WeatherManager()
        let vm = SavedLocationsPersistenceViewModel(weatherManager: weatherManager)
        
        return vm
    }
}

extension NetworkMonitor {
    static var preview: NetworkMonitor {
        let vm = NetworkMonitor()
        
        return vm
    }
}

extension LocationSearchViewModel {
    static var preview: LocationSearchViewModel {
        let vm = LocationSearchViewModel()
        
        return vm
    }
}
