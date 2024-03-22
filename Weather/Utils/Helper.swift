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
        case .blizzard:
            return K.ColorsConstants.cloudSnow
        case .blowingDust:
            return K.ColorsConstants.haze
        case .blowingSnow:
            return K.ColorsConstants.cloudSnow
        case .breezy:
            return K.ColorsConstants.wind
        case .clear:
            if isDaylight {
                return K.ColorsConstants.sunMaxColor
            }
            return Color.indigo
        case .cloudy:
            if isDaylight {
                return K.ColorsConstants.cloudSunColor
            }
            return K.ColorsConstants.cloudMoonColor
        case .drizzle:
            if isDaylight {
                return K.ColorsConstants.cloudSunRainColor
            }
            return K.ColorsConstants.cloudMoonRainColor
        case .flurries:
            return K.ColorsConstants.cloudSnow
        case .foggy:
            return K.ColorsConstants.cloudy
        case .freezingDrizzle:
            if isDaylight {
                return K.ColorsConstants.cloudSunRainColor
            }
            return K.ColorsConstants.cloudMoonRainColor
        case .freezingRain:
            if isDaylight {
                return K.ColorsConstants.cloudSunRainColor
            }
            return K.ColorsConstants.cloudMoonRainColor
        case .frigid:
            return K.ColorsConstants.cloudSnow
        case .hail:
            return K.ColorsConstants.cloudSnow
        case .haze:
            return K.ColorsConstants.haze
        case .heavyRain:
            if isDaylight {
                return K.ColorsConstants.cloudSunRainColor
            }
            return K.ColorsConstants.cloudMoonRainColor
        case .heavySnow:
            return K.ColorsConstants.cloudSnow
        case .hot:
            return K.ColorsConstants.maroon
        case .hurricane:
            return K.ColorsConstants.cloudBoltRainColor
        case .isolatedThunderstorms:
            return K.ColorsConstants.cloudBoltColor
        case .mostlyClear:
            if isDaylight {
                return K.ColorsConstants.sunMaxColor
            }
            return Color.indigo
        case .mostlyCloudy:
            if isDaylight {
                return K.ColorsConstants.cloudSunColor
            }
            return K.ColorsConstants.cloudMoonColor
        case .partlyCloudy:
            if isDaylight {
                return K.ColorsConstants.cloudSunColor
            }
            return K.ColorsConstants.cloudMoonColor
        case .rain:
            if isDaylight {
                return K.ColorsConstants.cloudSunRainColor
            }
            return K.ColorsConstants.cloudMoonRainColor
        case .scatteredThunderstorms:
            return K.ColorsConstants.cloudBoltRainColor
        case .sleet:
            return K.ColorsConstants.cloudSnow
        case .smoky:
            return K.ColorsConstants.haze
        case .snow:
            return K.ColorsConstants.cloudSnow
        case .strongStorms:
            return K.ColorsConstants.cloudBoltRainColor
        case .sunFlurries:
            return K.ColorsConstants.cloudSnow
        case .sunShowers:
            return K.ColorsConstants.cloudSunRainColor
        case .thunderstorms:
            return K.ColorsConstants.cloudBoltRainColor
        case .tropicalStorm:
            return K.ColorsConstants.cloudBoltRainColor
        case .windy:
            return K.ColorsConstants.wind
        case .wintryMix:
            return K.ColorsConstants.cloudSnow
        @unknown default:
            return K.ColorsConstants.sunMaxColor
        } 
    }
}
