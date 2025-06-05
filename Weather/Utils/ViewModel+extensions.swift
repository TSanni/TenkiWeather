//
//  WeatherViewModel+extension.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/2/25.
//

import Foundation


extension AppStateViewModel {
    static var preview: AppStateViewModel {
        let weatherManager = MockWeatherService()
        let coreLocationVM = CoreLocationViewModel()
        let vm = AppStateViewModel(
            locationViewModel: CoreLocationViewModel(),
            weatherViewModel: WeatherViewModel(weatherManager: weatherManager),
            persistence: SavedLocationsPersistenceViewModel(weatherManager: weatherManager, coreLocationModel: coreLocationVM)
        )
        
        return vm
    }
}

extension WeatherViewModel {
    static var preview: WeatherViewModel {
        let weatherManager = MockWeatherService()
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
        let weatherManager = MockWeatherService()
        let coreLocationVM = CoreLocationViewModel()

        let vm = SavedLocationsPersistenceViewModel(weatherManager: weatherManager, coreLocationModel: coreLocationVM)
        
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
