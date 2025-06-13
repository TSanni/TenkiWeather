//
//  Helper.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import WeatherKit
import SwiftUI

struct Helper {
    
    static func getShowTemperatureUnitPreference() -> Bool {
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
        case K.UserDefaultValue.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
    
    static func isMilitaryTime() -> Bool {
        UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: Jul 7, 10:08 PM
    static func getReadableMainDate(date: Date, timezoneIdentifier: String) -> String {
        let format = isMilitaryTime() ? K.TimeConstants.monthDayHourMinuteMilitary : K.TimeConstants.monthDayHourMinute
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM or 07 for military
    static func getReadableHourOnly(date: Date, timezoneIdentifier: String) -> String {
        let format = isMilitaryTime() ? K.TimeConstants.hourAndMinuteMilitary : K.TimeConstants.hourOnly
        
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
        let format = isMilitaryTime() ? K.TimeConstants.hourAndMinuteMilitary : K.TimeConstants.hourAndMinute
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        
        guard let date = date else { return "-" }
        return dateFormatter.string(from: date)
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
    
    @ViewBuilder
    static func getScene(weatherCondition: WeatherCondition) -> some View {
        switch weatherCondition {
        case .blizzard:
            SnowView(snowBirthRate: 90, snowVelocity: 100)
        case .blowingDust:
            EmptyView()
        case .blowingSnow:
            SnowView(snowBirthRate: 10, snowVelocity: 100)
        case .breezy:
            EmptyView()
        case .clear:
            CloudView(cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .cloudy:
            CloudView(cloudBirthRate: 1 / 5, cloudVelocity: 5)
        case .drizzle:
            RainView(rainBirthRate: 10, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .flurries:
            SnowView(snowBirthRate: 10, snowVelocity: 100)
        case .foggy:
            CloudView(cloudBirthRate: 1, cloudVelocity: 5)
        case .freezingDrizzle:
            RainView(rainBirthRate: 10, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .freezingRain:
            EmptyView()
        case .frigid:
            EmptyView()
        case .hail:
            SnowView(snowBirthRate: 5, snowVelocity: 500)
        case .haze:
            EmptyView()
        case .heavyRain:
            RainView(rainBirthRate: 200, rainVelocity: 700, cloudBirthRate: 1.5, cloudVelocity: 10)
        case .heavySnow:
            SnowView(snowBirthRate: 90, snowVelocity: 100)
        case .hot:
            EmptyView()
        case .hurricane:
            RainView(rainBirthRate: 200, rainVelocity: 700, cloudBirthRate: 1.5, cloudVelocity: 10)
        case .isolatedThunderstorms:
            RainView(rainBirthRate: 10, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .mostlyClear:
            CloudView(cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .mostlyCloudy:
            CloudView(cloudBirthRate: 1, cloudVelocity: 5)
        case .partlyCloudy:
            CloudView(cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .rain:
            RainView(rainBirthRate: 100, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .scatteredThunderstorms:
            RainView(rainBirthRate: 100, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .sleet:
            EmptyView()
        case .smoky:
            EmptyView()
        case .snow:
            SnowView(snowBirthRate: 10, snowVelocity: 75)
        case .strongStorms:
            EmptyView()
        case .sunFlurries:
            SnowView(snowBirthRate: 10, snowVelocity: 100)
        case .sunShowers:
            RainView(rainBirthRate: 100, rainVelocity: 500, cloudBirthRate: 1 / 10, cloudVelocity: 5)
        case .thunderstorms:
            RainView(rainBirthRate: 200, rainVelocity: 700, cloudBirthRate: 1.5, cloudVelocity: 10)
        case .tropicalStorm:
            RainView(rainBirthRate: 200, rainVelocity: 700, cloudBirthRate: 1.5, cloudVelocity: 10)
        case .windy:
            EmptyView()
        case .wintryMix:
            SnowView(snowBirthRate: 10, snowVelocity: 75)
        @unknown default:
            EmptyView()
        }
    }
    
    static func backgroundColor(weatherCondition: WeatherCondition, isDaylight: Bool = true) -> Color {
        switch weatherCondition {
        case .blizzard:
            return isDaylight ? Color.blizzardDaylightColor : Color.blizzardNightColor
        case .blowingDust:
            return isDaylight ? Color.blowingDustDaylightColor : Color.blowingDustNightColor
        case .blowingSnow:
            return isDaylight ? Color.blowingSnowDaylightColor : Color.blowingSnowNightColor
        case .breezy:
            return isDaylight ? Color.breezyDaylightColor : Color.breezyNightColor
        case .clear:
            return isDaylight ? Color.clearWeatherDaylightColor : Color.clearWearherNightColor
        case .cloudy:
            return isDaylight ? Color.cloudyDaylightColor : Color.cloudyNightColor
        case .drizzle:
            return isDaylight ? Color.drizzleDaylightColor : Color.drizzleNightColor
        case .flurries:
            return isDaylight ? Color.flurriesDaylightColor : Color.flurriesNightColor
        case .foggy:
            return isDaylight ? Color.foggyDaylightColor : Color.foggyNightColor
        case .freezingDrizzle:
            return isDaylight ? Color.freezingDrizzleDaylightColor : Color.freezingDrizzleNightColor
        case .freezingRain:
            return isDaylight ? Color.freezingRainDaylightColor : Color.freezingRainNightColor
        case .frigid:
            return isDaylight ? Color.frigidDaylightColor : Color.frigidNightColor
        case .hail:
            return isDaylight ? Color.hailDaylightColor : Color.hailNightColor
        case .haze:
            return isDaylight ? Color.hazeDaylightColor : Color.hazeNightColor
        case .heavyRain:
            return isDaylight ? Color.heavyRainDaylightColor : Color.heavyRainNightColor
        case .heavySnow:
            return isDaylight ? Color.heavySnowDaylightColor : Color.heavySnowNightColor
        case .hot:
            return isDaylight ? Color.hotDaylightColor : Color.hotNightColor
        case .hurricane:
            return isDaylight ? Color.hurricaneDaylightColor : Color.hurricaneNightColor
        case .isolatedThunderstorms:
            return isDaylight ? Color.isolatedThunderstormDaylightColor : Color.isolatedThunderstormNightColor
        case .mostlyClear:
            return isDaylight ? Color.mostlyClearDaylightColor : Color.mostlyClearNightColor
        case .mostlyCloudy:
            return isDaylight ? Color.mostlyCloudyDaylightColor : Color.mostlyCloudyNightColor
        case .partlyCloudy:
            return isDaylight ? Color.partyCloudyDaylightColor : Color.partyCloudyNightColor
        case .rain:
            return isDaylight ? Color.rainDaylightColor : Color.rainNightColor
        case .scatteredThunderstorms:
            return isDaylight ? Color.scatteredThunderstormsDaylightColor : Color.scatteredThunderstormsNightColor
        case .sleet:
            return isDaylight ? Color.sleetDaylightColor : Color.sleetNightColor
        case .smoky:
            return isDaylight ? Color.smokyDaylightColor : Color.smokyNightColor
        case .snow:
            return isDaylight ? Color.snowDaylightColor : Color.snowNightColor
        case .strongStorms:
            return isDaylight ? Color.strongStormsDaylightColor : Color.strongStormsNightColor
        case .sunFlurries:
            return isDaylight ? Color.sunFlurriesDaylightColor : Color.sunFlurriesNightColor
        case .sunShowers:
            return isDaylight ? Color.sunShowersDaylightColor : Color.sunShowersNightColor
        case .thunderstorms:
            return isDaylight ? Color.thunderstormDaylightColor : Color.thunderstormNightColor
        case .tropicalStorm:
            return isDaylight ? Color.tropicalStormDaylightColor : Color.tropicalStormNightColor
        case .windy:
            return isDaylight ? Color.windyDaylightColor : Color.windyNightColor
        case .wintryMix:
            return isDaylight ? Color.wintryMixDaylightColor : Color.wintryMixNightColor    
        @unknown default:
            return Color.clearWeatherDaylightColor
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
