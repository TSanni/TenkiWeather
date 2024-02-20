//
//  TodayWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation
import WeatherKit
import SwiftUI
import SpriteKit
// MARK: - Main Model
struct TodayWeatherModel: Identifiable {
    let id = UUID()
    let apparentTemperature: Measurement<UnitTemperature>
    let dewPoint: Measurement<UnitTemperature>
    let humidity: Double
    let temperature: Measurement<UnitTemperature>
    let pressure: Measurement<UnitPressure>
    let pressureTrend: PressureTrend
    let wind: WindData
    let condition: WeatherCondition
    let date: Date
    let isDaylight: Bool
    let uvIndexCategory: UVIndex.ExposureCategory
    let uvIndexValue: Int
    let visibility: Measurement<UnitLength>
    let symbolName: String
    let highTemperature: Measurement<UnitTemperature>
    let lowTemperature: Measurement<UnitTemperature>
    let precipitationChance: Double
    let sunData: SunData
    let hourlyWeather: [HourlyModel]
    let timezeone: Int
    
    
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        apparentTemperature:  Measurement(value: 50, unit: .fahrenheit), 
        dewPoint: Measurement(value: 50, unit: .fahrenheit), 
        humidity: 0.5,
        temperature: Measurement(value: 50, unit: .fahrenheit),
        pressure: Measurement(value: 20, unit: .inchesOfMercury),
        pressureTrend: .rising,
        wind: WindData.windDataHolder[0], 
        condition: .clear, date: Date.now,
        isDaylight: false, 
        uvIndexCategory: .extreme,
        uvIndexValue: 10, 
        visibility: Measurement(value: 5000, unit: .meters),
        symbolName: "sun.max", 
        highTemperature: Measurement(value: 50, unit: .fahrenheit),
        lowTemperature: Measurement(value: 50, unit: .fahrenheit),
        precipitationChance: 0.5,
        sunData: SunData.sunDataHolder,
        hourlyWeather: HourlyModel.hourlyTempHolderData,
        timezeone: 0
    )
    
}


// MARK: - Computed Properties
extension TodayWeatherModel {
    var feelsLikeTemperature: String {
        let temperature = apparentTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)

        return temperatureValueOnly
    }

    var dewPointDescription: String {
        let dewPointTemperature = dewPoint.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: dewPointTemperature.value)
        
        return temperatureValueOnly + dewPointTemperature.unit.symbol
    }
    
    var humidityPercentage: String {
        humidity.formatted(.percent)
    }
    
    var currentTemperature: String {
        let temperature = temperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var pressureString: String {
        let pressure = pressure.converted(to: .inchesOfMercury)
        let value = convertNumberToTwoFloatingPoints(number: pressure.value)
        let symbol = pressure.unit.symbol
        return value + "\n" + symbol
    }
        
    var pressureValue: Double {
        let pressure = pressure.converted(to: .inchesOfMercury)
        let value = pressure.value
        return value
    }
    
    var pressureDescription: String {
        switch pressureTrend {
        case .rising:
            return "The pressure is rising."
        case .falling:
            return "The pressure is falling."
        case .steady:
            return "The pressure is not changing."
        default:
            return "No pressure data"
        }
    }
    
    var weatherDescription: String {
        return condition.description
    }
    
    var readableDate: String {
        return getReadableMainDate(date: date, timezoneOffset: timezeone)
    }
    
    var uvIndexNumberDescription: String {
        uvIndexValue.description
    }
    
    var uvIndexCategoryDescription: String {
        uvIndexCategory.description
    }
        
    var uvIndexActionRecommendation: String {
        switch uvIndexCategory {
        case .low:
            return "Minimal sun protection needed."
        case .moderate:
            return "Use Sun Protection."
        case .high:
            return "Extra sun protection needed."
        case .veryHigh:
            return "Extra sun protection needed."
        case .extreme:
            return "Extra sun protection needed."
        }
    }
    
    var uvIndexColor: Color {
        switch uvIndexCategory {
        case .low:
            return Color.green
        case .moderate:
            return Color.orange
        case .high:
            return Color.red
        case .veryHigh:
            return Color.red
        case .extreme:
            return Color.red
        }
    }
    
    var visibilityValue: String {
        let unit = getUnitLength()
        let visibility = visibility.converted(to: unit)
        let formattedVisibilityValue = convertNumberToZeroFloatingPoints(number: visibility.value)
        let symbol = visibility.unit.symbol
        return formattedVisibilityValue + symbol
    }

    var visiblityDescription: String {
        let visibilityValue = visibility.converted(to: .meters).value
        
        switch visibilityValue {
        case 0...926:
            return "Very poor visibility."
        case 927...3704:
            return "Weather conditions are affecting visibility."
        case 3705...9260:
            return "Weather conditions are affecting visibility."
        case 9261...500000:
            return "Perfectly clear view."
        default:
            return "Unable to determine visibility."
        }
    }
    
    var todayHigh: String {
        let temperature = highTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var todayLow: String {
        let temperature = lowTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var chanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent)
    }
    
    var backgroundColor: Color {
        K.getBackGroundColor(symbol: symbolName)
    }
    
    var scene: SKScene? {
        return  K.getScene(symbol: symbolName)
    }
}

//MARK: Private functions
extension TodayWeatherModel {
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    private func getUnitTemperature() -> UnitTemperature {
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
    private func getReadableMainDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.Time.monthDayHourMinuteFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToTwoFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.2f", number)
        return convertedStringNumber
    }
    
    private func getUnitLength() -> UnitLength {
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
