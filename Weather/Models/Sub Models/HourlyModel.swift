//
//  HourlyModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

/// Consists of temperatures and the dates
struct HourlyModel: Identifiable {
    let id = UUID()
    let temperature: Measurement<UnitTemperature>
    let wind: WindData
    let date: Date
    let precipitationChance: Double
    let symbol: String
    let timezone: Int

    var hourTemperature: String {
        let temperature = temperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var readableDate: String {
        getReadableHourOnly(date: date, timezoneOffset: timezone)
    }
    
    var chanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent)
    }
        
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
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM
    private func getReadableHourOnly(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    static let hourlyTempHolderData: [HourlyModel] = [
        HourlyModel(temperature: Measurement(value: 50, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date.now, precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        HourlyModel(temperature: Measurement(value: 50, unit: .fahrenheit), wind: WindData.windDataHolder[1], date: Date.now, precipitationChance: 0.5, symbol: "sun.max", timezone: 0),


    ]
}





