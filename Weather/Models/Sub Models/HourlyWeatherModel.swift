//
//  HourlyWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation
import WeatherKit

/// Consists of temperatures and the dates
struct HourlyWeatherModel: Identifiable {
    let id = UUID()
    let temperature: Measurement<UnitTemperature>
    let wind: WindModel
    let date: Date
    let precipitationChance: Double
    let symbol: String
    let timezoneIdentifier: String
    let condition: WeatherCondition
    let isDayLight: Bool

    var hourTemperature: String {
        let temperature = temperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var windTruth: WindModel {
        WindModel(speed: wind.speed, compassDirection: wind.compassDirection)
    }
    
    var readableDate: String {
        Helper.getReadableHourOnly(date: date, timezoneIdentifier: timezoneIdentifier)
    }
    
    var chanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent)
    }
}
