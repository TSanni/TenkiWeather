//
//  DailyWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/9/23.
//

import Foundation
import WeatherKit
import SwiftUI
import SpriteKit

//MARK: - Main Model
struct DailyWeatherModel: Identifiable {
    let id = UUID()
    let highTemperature: Measurement<UnitTemperature>
    let lowTemperature: Measurement<UnitTemperature>
    let precipitation: Precipitation
    let precipitationChance: Double
    let snowfallAmount: Measurement<UnitLength>
    let moon: MoonEvents? //TODO: create a MoonEvents object
    let sun: SunData
    let wind: WindData
    let date: Date
    let condition: WeatherCondition
    let uvIndexValue: Int
    let uvIndexCategory: UVIndex.ExposureCategory
    let symbolName: String
    let precipitationAmount: Measurement<UnitLength>
    let hourlyWeather: [HourlyWeatherModel]
    let timezone: Int
    
    var dayHigh: String {
        let temperature = highTemperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var dayLow: String {
        let temperature = lowTemperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var precipitationType: String {
        precipitation.description
    }
    
    var dayChanceOfPrecipitation: String {
        return precipitationChance.formatted(.percent) + " chance of precipitation"
    }
    
    //snowfallAmount
    //rainfallAmount
    //moon events
    
    var readableDate: String {
        return Helper.getDayOfWeekAndDate(date: date, timezoneOffset: timezone)
    }
    
    var dayWeatherDescription: String {
        condition.description
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
    
    //precipitationAmount
    
    var backgroundColor: Color {
        let condition = condition
        return Helper.backgroundColor(weatherCondition: condition)
    }
    
    var scene: SKScene? {
        let condition = condition
        return Helper.getScene(weatherCondition: condition)
    }
}

