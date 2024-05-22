//
//  HourlyWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

/// Consists of temperatures and the dates
struct HourlyWeatherModel: Identifiable {
    let id = UUID()
    let temperature: Measurement<UnitTemperature>
    let wind: WindData
    let date: Date
    let precipitationChance: Double
    let symbol: String
    let timezone: Int

    var hourTemperature: String {
        let temperature = temperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var windTruth: WindData {
        WindData(speed: wind.speed, compassDirection: wind.compassDirection)
    }
    
    var readableDate: String {
        Helper.getReadableHourOnly(date: date, timezoneOffset: timezone)
    }
    
    var chanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent)
    }
    
    static let hourlyTempHolderData: [HourlyWeatherModel] = [
        HourlyWeatherModel(temperature: Measurement(value: 50, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 3600), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 70, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 7200), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 40, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 10800), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 50, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 14400), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 80, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 18000), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 85, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 21600), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),
        
        HourlyWeatherModel(temperature: Measurement(value: 70, unit: .fahrenheit), wind: WindData.windDataHolder[0], date: Date(timeIntervalSince1970: 25200), precipitationChance: 0.5, symbol: "sun.max", timezone: 0),

    ]
}





