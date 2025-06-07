//
//  Helper.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import WeatherKit
import SpriteKit
import SwiftUI

enum Helper {
    
    static func getShowTemperatureUnitPreference() -> Bool{
        let showTemperatureUnit = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.showTemperatureUnitKey)
        return showTemperatureUnit
    }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    static func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    static func convertNumberToTwoFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.2f", number)
        return convertedStringNumber
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    static func getUnitTemperature() -> UnitTemperature {
        let savedUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch savedUnitTemperature {
        case K.UserDefaultValue.fahrenheit:
            return .fahrenheit
        case K.UserDefaultValue.celsius:
            return .celsius
        case   K.UserDefaultValue.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: Jul 7, 10:08 PM
    static func getReadableMainDate(date: Date, timezoneIdentifier: String) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String
        if militaryTime {
            format = K.TimeConstants.monthDayHourMinuteMilitary
        } else {
            format = K.TimeConstants.monthDayHourMinute
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM or 07 for military
    static func getReadableHourOnly(date: Date, timezoneIdentifier: String) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String
        
        if militaryTime {
            format = K.TimeConstants.hourAndMinuteMilitary
        } else {
            format = K.TimeConstants.hourOnly
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)

        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    static func getDayOfWeekAndDate(date: Date, timezoneIdentifier: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.TimeConstants.dayOfWeekAndDate
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)

        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: 1:07 PM or 13:07 for military
    static func getReadableHourAndMinute(date: Date?, timezoneIdentifier: String) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String

        if militaryTime {
            format = K.TimeConstants.hourAndMinuteMilitary
        } else {
            format = K.TimeConstants.hourAndMinute
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        if let date = date {
            let readableHourAndMinute = dateFormatter.string(from: date)
            return readableHourAndMinute
        } else {
            return "-"
        }
    }
    
    /// Returns a UnitLength based on stored value of UnitSpeed in UserDefaults
    static func getUnitLength() -> UnitLength {
       let unitSpeed = getUnitSpeed()
       
       switch unitSpeed {
           case .milesPerHour:
               return .miles
           case .kilometersPerHour:
               return .kilometers
           case .metersPerSecond:
               return .meters
           default:
               return .miles
       }
   }
    
    /// Checks UserDefaults and returns a UnitSpeed based on stored value
    static func getUnitSpeed() -> UnitSpeed {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitDistanceKey)
        
        switch chosenUnitDistance {
        case K.UserDefaultValue.mph:
            return .milesPerHour
        case K.UserDefaultValue.kiloPerHour:
            return .kilometersPerHour
        case K.UserDefaultValue.meterPerSecond:
            return .metersPerSecond
        default:
            return .milesPerHour
        }
    }
    
    
    /// Checks UserDefaults and returns a UnitLength based on stored value
    static func getUnitPrecipitation() -> UnitLength {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitPrecipitationKey)
        
        switch chosenUnitDistance {
        case K.UserDefaultValue.inches:
            return .inches
        case K.UserDefaultValue.millimeters:
            return .millimeters
        case K.UserDefaultValue.centimeters:
            return .centimeters
        default:
            return .inches
        }
    }
    
    static func getScene(weatherCondition: WeatherCondition) -> SKScene? {
        let condition = weatherCondition
        switch condition {
        case .blizzard:
            return SnowScene()
        case .blowingDust:
            return nil
        case .blowingSnow:
            return SnowScene()
        case .breezy:
            return nil
        case .clear:
            return nil
        case .cloudy:
            return nil
        case .drizzle:
            return RainScene()
        case .flurries:
            return SnowScene()
        case .foggy:
            return nil
        case .freezingDrizzle:
            return nil
        case .freezingRain:
            return nil
        case .frigid:
            return nil
        case .hail:
            return nil
        case .haze:
            return nil
        case .heavyRain:
            return RainScene()
        case .heavySnow:
            return SnowScene()
        case .hot:
            return nil
        case .hurricane:
            return nil
        case .isolatedThunderstorms:
            return nil
        case .mostlyClear:
            return nil
        case .mostlyCloudy:
            return nil
        case .partlyCloudy:
            return nil
        case .rain:
            return RainScene()
        case .scatteredThunderstorms:
            return nil
        case .sleet:
            return nil
        case .smoky:
            return nil
        case .snow:
            return SnowScene()
        case .strongStorms:
            return nil
        case .sunFlurries:
            return SnowScene()
        case .sunShowers:
            return RainScene()
        case .thunderstorms:
            return nil
        case .tropicalStorm:
            return RainScene()
        case .windy:
            return nil
        case .wintryMix:
            return nil
        @unknown default:
            return nil
        }
    }
    
    static func backgroundColor(weatherCondition: WeatherCondition, isDaylight: Bool = true) -> Color {
        let condition = weatherCondition
        let isDaylight = isDaylight
        
        switch condition {
        case .blizzard, .snow, .flurries, .frigid, .hail, .heavySnow, .sleet, .sunFlurries, .wintryMix, .blowingSnow:
            return Color.cloudSnow
        case .blowingDust, .haze, .smoky:
            return Color.haze
        case .breezy, .windy:
            return Color.wind
        case .clear, .mostlyClear:
            return isDaylight ? Color.sunMaxColor : Color.moonAndStarsColor
        case .cloudy, .partlyCloudy, .mostlyCloudy:
            return isDaylight ? Color.cloudSunColor : Color.cloudMoonColor
        case .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .rain:
            return isDaylight ? Color.cloudSunRainColor : Color.cloudMoonRainColor
        case .foggy:
            return Color.foggy
        case .hot:
            return Color.maroon
        case .hurricane, .scatteredThunderstorms, .strongStorms, .thunderstorms, .tropicalStorm:
            return Color.cloudBoltRainColor
        case .isolatedThunderstorms:
            return Color.cloudBoltColor
        case .sunShowers:
            return Color.cloudSunRainColor
        @unknown default:
            return Color.sunMaxColor
        }
    }
    
    /// Takes a CompassDirection and returns a Double which indicates the angle the current compass direction.
    /// One use can be to properly set rotation effects on views
    static func getRotation(direction: Wind.CompassDirection) -> Double {
        // starting pointing east. Subtract 90 to point north
        // Think of this as 0 on a pie chart
        let zero: Double = 45

        switch direction {
            case .north:
                return zero - 90
            case .northNortheast:
                return zero - 67.5
            case .northeast:
                return zero - 45
            case .eastNortheast:
                return zero - 22.5
            case .east:
                return zero
            case .eastSoutheast:
                return zero + 22.5
            case .southeast:
                return zero + 45
            case .southSoutheast:
                return zero + 67.5
            case .south:
                return zero + 90
            case .southSouthwest:
                return zero + 112.5
            case .southwest:
                return zero + 135
            case .westSouthwest:
                return zero + 157.5
            case .west:
                return zero - 180
            case .westNorthwest:
                return zero - 157.5
            case .northwest:
                return zero - 135
            case .northNorthwest:
                return zero - 112.5
        }
    }
    
    /// Manually checks for SF Symbols that do not have the fill option and returns that image without .fill added.
    /// Otherwise, .fill is added to the end of the symbol name
    //TODO: Add more sf symbols
    static func getImage(imageName: String) -> String {
        switch imageName {
            case "wind":
                return imageName
            case "snowflake":
                return imageName
            case "tornado":
                return imageName
            case "snow":
                return imageName
            default:
                return imageName + ".fill"
        }
    }
}
