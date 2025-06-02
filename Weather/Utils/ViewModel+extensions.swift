//
//  WeatherViewModel+extension.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/2/25.
//

import Foundation

extension AppStateViewModel {
    static var preview: AppStateViewModel {
        let weatherManager = WeatherManager.shared
        let vm = AppStateViewModel(
            weatherManager: weatherManager,
            locationViewModel: CoreLocationViewModel(),
            weatherViewModel: WeatherViewModel(),
            persistence: SavedLocationsPersistenceViewModel()
        )
        
        return vm
    }
}

extension WeatherViewModel {
    static var preview: WeatherViewModel {
        let vm = WeatherViewModel()
        return vm
    }
}
