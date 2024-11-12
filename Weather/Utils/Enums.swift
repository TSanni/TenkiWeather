//
//  Enums.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/6/24.
//

import Foundation

enum WeatherErrors: Error, LocalizedError {
    case failedToGetWeatherKitData
    
    var errorDescription: String? {
        switch self {
        case .failedToGetWeatherKitData:
            return "Weather request failed"
        }
    }
    
    
    var recoverySuggestion: String? {
        switch self {
        case .failedToGetWeatherKitData:
            return "Check your network connection and try again."
        }
    }
}

enum CoreDataErrors: Error, LocalizedError {
    case failedToLoad
    case failedToFetch
    case failedToFetchWeatherPlacesWithTaskGroup
    case failedToSave
    case failedToFetchCurrentWeather
    
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

enum PrecipitationUnits: String, CaseIterable {
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
}
