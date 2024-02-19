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
    let temperature: Measurement<UnitTemperature>
    let date: Date
    let highTemperature: Measurement<UnitTemperature>
    let lowTemperature: Measurement<UnitTemperature>
    let symbol: String
    let condition: WeatherCondition
    let precipitationChance: Double
    let currentDetails: DetailsModel
    let wind: WindData
    let sunData: SunData
    let isDaylight: Bool
    let hourlyWeather: [HourlyModel]
    let timezeone: Int
    
    
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        apparentTemperature:  Measurement(value: 50, unit: .fahrenheit), 
        temperature: Measurement(value: 50, unit: .fahrenheit), 
        date: Date.now,
        highTemperature: Measurement(value: 50, unit: .fahrenheit),
        lowTemperature: Measurement(value: 50, unit: .fahrenheit),
        symbol: "sun.max",
        condition: .clear,
        precipitationChance: 0.5,
        currentDetails: DetailsModel.detailsDataHolder,
        wind: WindData.windDataHolder[0],
        sunData: SunData.sunDataHolder,
        isDaylight: false,
        hourlyWeather: HourlyModel.hourlyTempHolderData,
        timezeone: 0
    )
    
}


// MARK: - Computed Properties
extension TodayWeatherModel {
    
    var readableDate: String {
        return getReadableMainDate(date: date, timezoneOffset: timezeone)
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
    
    var currentTemperature: String {
        let temperature = temperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly + "°"
    }
    
    var feelsLikeTemperature: String {
        let temperature = apparentTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        print("**********************VALUE OF FEELSLIKE TEMP: \(temperatureValueOnly)********************************************")

        return temperatureValueOnly
    }

    var weatherDescription: String {
        return condition.description
    }
    
    var chanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent)
    }
    
    var backgroundColor: Color {
        K.getBackGroundColor(symbol: symbol)
    }
    
    var scene: SKScene? {
        print("THE SYMBOL FOR SCENE: \(symbol)")
        return  K.getScene(symbol: symbol)
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
            print("CAN'T DETERMINE UNIT TEMPERATURE")
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
}
