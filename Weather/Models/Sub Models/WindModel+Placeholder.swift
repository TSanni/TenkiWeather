//
//  WindData+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/4/24.
//

import Foundation
import WeatherKit


struct WindModelPlaceholder {
    /// Holder data for wind details
    static let windDataHolder: [WindData] = [
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 50, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
        WindData(speed: Measurement(value: 20, unit: .milesPerHour), compassDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north),
    ]
}
