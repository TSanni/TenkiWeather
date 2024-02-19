//
//  WindModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation
import WeatherKit
import SwiftUI

//MARK: - Wind Data Model : Will be part of main model

/// Consists of windSpeed, compassDirection, time, windDescription, and readableWindDirection
struct WindData: Identifiable {
    let id = UUID()
    let speed: Measurement<UnitSpeed>
    let compassDirection: Wind.CompassDirection
    let time: String?
    
    /// Computed property uses the wind speed and returns a string description
    var windDescription: String {
        let speed = speed.converted(to: .milesPerHour)
        
            switch speed.value {
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
        }
    
    /// Computed property converts the enum wind directions to a readable string format
    var readableWindDirection: String {
        switch compassDirection {
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
    
    /// Computed property will update the color based on wind speed
    // TODO: Colors not updating properly based on unit and value
    var windColor: Color {
        
        let light = Color(uiColor: #colorLiteral(red: 0.08248766512, green: 0.2948074937, blue: 1, alpha: 1))
        let breeze = Color(uiColor: #colorLiteral(red: 0.2198026478, green: 0.6681205034, blue: 0.29497841, alpha: 1))
        let gale = Color(uiColor: #colorLiteral(red: 1, green: 0.7626845241, blue: 0.04172243923, alpha: 1))
        let strongGale = #colorLiteral(red: 0.9998317361, green: 0.7493718266, blue: 0, alpha: 1)
        let storm = #colorLiteral(red: 1, green: 0.6042675376, blue: 0.395904392, alpha: 1)
        let violentStorm = Color.orange
        let hurricane = Color.red
        
        let speed = speed.converted(to: .milesPerHour)
 
        switch speed.value {
        case 0...12://
            return light
        case 13...31:
            return breeze
        case 32...38:
            return gale
        case 39...54:
            return Color(uiColor: strongGale)
        case 55...63:
            return Color(uiColor: storm)
        case 64...72:
            return violentStorm
        case 73...500:
            return hurricane
        default:
            return light
        }
        
    }
    
    var windSpeed: String {
        let speed = speed.converted(to: getUnitSpeed())
        let windSpeedValueOnly = convertNumberToZeroFloatingPoints(number: speed.value)
        return windSpeedValueOnly
    }
    
    var speedUnit: String {
        return speed.converted(to: getUnitSpeed()).unit.symbol
    }

    /// Holder data for wind details
    static let windDataHolder: [WindData] = [
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "1 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "2 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "3 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "4 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "5 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "6 AM"),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "7 AM"),
    ]
}

// MARK: - Private Functions
extension WindData {
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    private func getUnitSpeed() -> UnitSpeed {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitDistanceKey)
        
        switch chosenUnitDistance {
        case  K.DistanceUnits.mph:
            return .milesPerHour
        case K.DistanceUnits.kiloPerHour:
            return .kilometersPerHour
        case K.DistanceUnits.meterPerSecond:
            return .metersPerSecond
        default:
            return .milesPerHour
        }
    }
}
