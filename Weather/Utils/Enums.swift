//
//  Enums.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/6/24.
//

import Foundation

enum Errors: Error {
    case failedToGetWeatherFromWeatherKit
    case failedToGetWeatherForWeatherViewModel
    case failedToGetLocalWeatherWithWeatherKit
    
}

enum WeatherErrors: Error {
    case failedToGetWeatherKitData
}

extension WeatherErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .failedToGetWeatherKitData:
                return NSLocalizedString(
                          "Check your network connection and try again.",
                          comment: ""
                      )
        }
    }
}

enum GeocodingErrors: Error {
    case reverseGeocodingError
    case goecodingError
}

enum WeatherTabs: Int, CaseIterable {
    case today = 0
    case tomorrow = 1
    case multiDay = 2
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .tomorrow:
            return "Tomorrow"
        case .multiDay:
            return "10 Days"

        }
    }
}

enum TemperatureUnits: String, CaseIterable {
    case fahrenheit = "Fahrenheit"
    case celsius = "Celsius"
    case kelvin = "Kelvin"
    
    var title: String {
        switch self {
        case .fahrenheit:
            return "Fahrenheit"
        case .celsius:
            return "Celsius"
        case .kelvin:
            return "Kelvin"
        }
    }
    
    var symbol: String {
        switch self {
        case .fahrenheit:
            return "(°F)"
        case .celsius:
            return "(°C)"
        case .kelvin:
            return "(K)"
        }
    }
}

enum DistanceUnits: String, CaseIterable {
    case miles
    case kilometer
    case meters
    
    var title: String {
        switch self {
        case .miles:
            "Miles"
        case .kilometer:
            "Kilometers"
        case .meters:
            "Meters"
        }
    }
}
