//
//  TodayWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation
import WeatherKit

//MARK: - Main Model
struct TodayWeatherModel: Identifiable {
    let id = UUID()
    let date: String
    let todayHigh: String
    let todayLow: String
    let currentTemperature: String
    let feelsLikeTemperature: String
    let symbol: String
    let weatherDescription: String
    let chanceOfPrecipitation: String
    let currentDetails: DetailsModel
    let todayWind: WindData
    let todayHourlyWind: [WindData]
    let sunData: SunData
    let isDaylight: Bool
    let hourlyTemperatures: [HourlyTemperatures]
    let temperatureUnit: String

    
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        date: "-",
        todayHigh: "-",
        todayLow: "-",
        currentTemperature: "-",
        feelsLikeTemperature: "-",
        symbol: "sun.min",
        weatherDescription: "-",
        chanceOfPrecipitation: "-",
        currentDetails: DetailsModel.detailsDataHolder,
        todayWind: WindData.windDataHolder,
        todayHourlyWind: [WindData.windDataHolder],
        sunData: SunData.sunDataHolder,
        isDaylight: false,
        hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], temperatureUnit: "F"

    )
    
}


/// Consists of temperatures and the dates
struct HourlyTemperatures: Identifiable {
    let id = UUID()
    let temperature: String
    let date: String
    let symbol: String
    let chanceOfPrecipitation: String

    
    static let hourlyTempHolderData = HourlyTemperatures(temperature: "-", date: "-", symbol: "sun.min", chanceOfPrecipitation: "-")
}

//MARK: - Details Model : Will be part of main model
struct DetailsModel {
    let humidity: String?
    let dewPoint: String?
    let pressure: String?
    let uvIndex: String
    let visibility: String?
    let sunData: SunData?

    /// Holder data for today's current weather details
    static let detailsDataHolder = DetailsModel(humidity: "-", dewPoint: "-", pressure: "-", uvIndex: "-", visibility: "-", sunData: SunData.sunDataHolder)
}

//MARK: - Wind Data Model : Will be part of main model

/// Consists of windSpeed, windDirection, time, windDescriptionForMPH, and readableWindDirection
struct WindData: Identifiable {
    let id = UUID()
    let windSpeed: String
    let windDirection: Wind.CompassDirection
    let time: String?
    
    /// Computed property uses the wind speed and returns a string description
    var windDescriptionForMPH: String {
        
        if let numWindSpeed = Int(windSpeed) {
            switch numWindSpeed {
                case 1...3:
                    return "Light Air"
                case 4...7:
                    return "Light Breeze"
                case 8...12:
                    return "Gentle Breeze"
                case 13...18:
                    return "Moderate Breeze"
                case 19...24:
                    return "Fresh Breeze"
                case 25...31:
                    return "Strong Breeze"
                case 32...38:
                    return "Near Gale"
                case 39...46:
                    return "Gale"
                case 47...54:
                    return "Strong Gale"
                case 55...63:
                    return "Whole Gale"
                case 64...75:
                    return "Storm Force"
                case 76...1000:
                    return "Hurricane Force"
                default:
                    return "Calm"
            }
        } else {
            return "No wind data"
        }
    }
    
    
    /// Computed property converts the enum wind directions to a readable string format
    var readableWindDirection: String {
        switch windDirection {
            case .north:
                return "North"
            case .northNortheast:
                return "North Northeast"
            case .northeast:
                return "Northeast"
            case .eastNortheast:
                return "East Northeast"
            case .east:
                return "East"
            case .eastSoutheast:
                return "East Southeast"
            case .southeast:
                return "Southeast"
            case .southSoutheast:
                return "South Southeast"
            case .south:
                return "South"
            case .southSouthwest:
                return "South Southwest"
            case .southwest:
                return "Southwest"
            case .westSouthwest:
                return "West Southwest"
            case .west:
                return "West"
            case .westNorthwest:
                return "West Northwest"
            case .northwest:
                return "Northwest"
            case .northNorthwest:
                return "North Northwest"
        }
    }
    
    
    /// Holder data for wind details
    static let windDataHolder = WindData(windSpeed: "-", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: nil)
}


//struct HourlyTemps: Identifiable {
//    let id = UUID()
//    let temp: String
//    let time: String
//    
//    static let hourlyTempsHolderData = HourlyTemps(temp: "-", time: "-")
//}


