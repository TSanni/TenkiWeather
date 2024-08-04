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
}
