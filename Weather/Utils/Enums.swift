//
//  Enums.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/6/24.
//

import Foundation

enum WeatherErrors: Error, LocalizedError {
    case failedToGetWeatherKitData
    case locationNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .failedToGetWeatherKitData:
            return "Weather request failed"
        case .locationNotAvailable:
            return "Location not available"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .failedToGetWeatherKitData:
            return "Check your network connection and try again."
        case .locationNotAvailable:
            return "Unable to get weather for this location. Please try a different location."
        }
    }
}

enum CoreDataErrors: Error, LocalizedError {
    case failedToLoad
    case failedToFetch
    case failedToFetchWeatherPlacesWithTaskGroup
    case failedToSave
    case failedToFetchCurrentWeather
    case locationSaveLimitReached
    
    var errorDescription: String? {
        switch self {
        case .failedToFetch:
            return "Failed to load save locations"
        case .failedToFetchWeatherPlacesWithTaskGroup:
            return "Weather request for saved locations failed"
        case .failedToSave:
            return "Failed to save location"
        case .failedToFetchCurrentWeather:
            return "Weather request for saved locations failed"
        case .failedToLoad:
            return "Failed to load saved data"
        case .locationSaveLimitReached:
            return "Unable to save location"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .failedToFetch:
            return "Please try again."
        case .failedToFetchWeatherPlacesWithTaskGroup:
            return "Please check your network connection and try again."
        case .failedToSave:
            return "Please try again."
        case .failedToFetchCurrentWeather:
            return "Please check your network connection and try again."
        case .failedToLoad:
            return "Please check your network connection or reload the app."
        case .locationSaveLimitReached:
            return "You can save up to 20 saved locations. Delete one and try again."
        }
    }
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
    case fahrenheit
    case celsius
    case kelvin
    
    var title: String {
        switch self {
        case .fahrenheit:
            return "fahrenheit"
        case .celsius:
            return "celsius"
        case .kelvin:
            return "kelvin"
        }
    }
    
    var symbol: String {
        switch self {
        case .fahrenheit:
            return "°F"
        case .celsius:
            return "°C"
        case .kelvin:
            return "K"
        }
    }
}

enum DistanceUnits: String, CaseIterable {
    case miles
    case kilometers
    case meters
    
    var title: String {
        switch self {
        case .miles:
            "miles"
        case .kilometers:
            "kilometers"
        case .meters:
            "meters"
        }
    }
    
    var distanceSymbol: String {
        switch self {
        case .miles:
            "mi"
        case .kilometers:
            "km"
        case .meters:
            "m"
        }
    }
    
    var speedSymbol: String {
        switch self {
        case .miles:
            "mph"
        case .kilometers:
            "km/h"
        case .meters:
            "m/s"
        }
    }
}

enum LengthUnits: String, CaseIterable {
    case inches
    case millimeters
    case centimeters
    
    var title: String {
        switch self {
        case .inches:
            "inches"
        case .millimeters:
            "millimeters"
        case .centimeters:
            "centimeters"
        }
    }
    
    var symbol: String {
        switch self {
        case .inches:
            "in"
        case .millimeters:
            "mm"
        case .centimeters:
            "cm"
        }
    }
}

enum PressureUnits: String, CaseIterable {
    case inchesOfMercury
    case bars
    case millibars
    case millimetersOfMercury
    
    var title : String {
        switch self {
        case .inchesOfMercury:
            "inchesOfMercury"
        case .bars:
            "bars"
        case .millibars:
            "millibars"
        case .millimetersOfMercury:
            "millimetersOfMercury"
        }
    }
    
    var titleForUI : String {
        switch self {
        case .inchesOfMercury:
            "inches of mercury"
        case .bars:
            "bars"
        case .millibars:
            "millibars"
        case .millimetersOfMercury:
            "millimeters of mercury"
        }
    }
    
    var symbol: String {
        switch self {
        case .inchesOfMercury:
            "inHg"
        case .bars:
            "bar"
        case .millibars:
            "mbar"
        case .millimetersOfMercury:
            "mmHg"
        }
    }
}

