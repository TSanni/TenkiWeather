//
//  Enums.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/6/24.
//

import Foundation


enum WeatherErrors: Error {
    case failedToGetWeatherKitData
    
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

enum WeatherTabs: Int, CaseIterable {
    case today = 0
    case tomorrow
    case multiDay
    
    
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
}

enum DistanceUnits: String, CaseIterable {
    case miles = "Miles per hour"
    case kilometer = "Kilometers per hour"
    case meters = "Meters per second"
}



enum GeocodingErrors: Error {
    case reverseGeocodingError
    case goecodingError
}
