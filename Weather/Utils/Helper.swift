//
//  Helper.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation

struct Helper {
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
        case K.TemperatureUnitsConstants.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnitsConstants.celsius:
            return .celsius
        case   K.TemperatureUnitsConstants.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: Jul 7, 10:08 PM
    static func getReadableMainDate(date: Date, timezoneOffset: Int) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String
        if militaryTime {
            format = K.TimeConstants.monthDayHourMinuteMilitary
        } else {
            format = K.TimeConstants.monthDayHourMinute
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM
    static func getReadableHourOnly(date: Date, timezoneOffset: Int) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String
        
        if militaryTime {
            format = K.TimeConstants.hourOnlyMilitary
        } else {
            format = K.TimeConstants.hourOnly
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    static func getDayOfWeekAndDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.TimeConstants.dayOfWeekAndDate
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: 12:07 PM
    static func getReadableHourAndMinute(date: Date?, timezoneOffset: Int) -> String {
        let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
        var format: String

        if militaryTime {
            format = K.TimeConstants.hourAndMinuteMilitary
        } else {
            format = K.TimeConstants.hourAndMinute
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
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
        case  K.DistanceUnitsConstants.mph:
            return .milesPerHour
        case K.DistanceUnitsConstants.kiloPerHour:
            return .kilometersPerHour
        case K.DistanceUnitsConstants.meterPerSecond:
            return .metersPerSecond
        default:
            return .milesPerHour
        }
    }
}
