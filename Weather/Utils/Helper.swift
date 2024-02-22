//
//  Helper.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation

class Helper {
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    static func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    static func getUnitTemperature() -> UnitTemperature {
        let savedUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch savedUnitTemperature {
        case K.TemperatureUnits.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnits.celsius:
            return .celsius
        case   K.TemperatureUnits.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: July 7, 10:08 PM
    static func getReadableMainDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.Time.monthDayHourMinuteFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM
    static func getReadableHourOnly(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    static func getDayOfWeekAndDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    static func convertNumberToTwoFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.2f", number)
        return convertedStringNumber
    }
    
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
    
    static func getUnitSpeed() -> UnitSpeed {
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
