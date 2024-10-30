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
    let moon: MoonEvents? //TODO: create a MoonEvents object
    let sun: SunModel
    let wind: WindModel
    let date: Date
    let condition: WeatherCondition
    let uvIndexValue: Int
    let uvIndexCategory: UVIndex.ExposureCategory
    let symbolName: String
    let hourlyWeather: [HourlyWeatherModel]
    let timezone: Int
    let precipitationAmountByType: PrecipitationAmountByType?
    
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
        return precipitation.description
    }
    
    func getAmountOfPrecipitation(value: Double, unit: String, type: String) -> String {
        if value < 0.01 {
            return "Less than 0.01 \(unit) of \(type) expected."
        } else if value < 1 {
            let reducedNumber = Helper.convertNumberToTwoFloatingPoints(number: value)
            return "\(reducedNumber) \(unit) of \(type) expected."
        } else {
            let reducedNumber = Helper.convertNumberToZeroFloatingPoints(number: value)
            return "\(reducedNumber) \(unit) of \(type) expected."
        }
        
        
    }
    
    var dayChanceOfPrecipitation: String {
        if let precipitationType = precipitationAmountByType {
            switch precipitation {
            case .none:
                return "No precipitation."
            case .hail:
                let hailAmount = precipitationType.hail.converted(to: Helper.getUnitPrecipitation())
                return getAmountOfPrecipitation(value: hailAmount.value, unit: hailAmount.unit.symbol, type: "hail")
            case .mixed:
                let mixedAmount = precipitationType.mixed.converted(to: Helper.getUnitPrecipitation())
                return getAmountOfPrecipitation(value: mixedAmount.value, unit: mixedAmount.unit.symbol, type: "wintry mix")
            case .rain:
                let rainfallAmount = precipitationType.rainfall.converted(to: Helper.getUnitPrecipitation())
                return getAmountOfPrecipitation(value: rainfallAmount.value, unit: rainfallAmount.unit.symbol, type: "rain")

            case .sleet:
                let sleetAmount = precipitationType.sleet.converted(to: Helper.getUnitPrecipitation())
                return getAmountOfPrecipitation(value: sleetAmount.value, unit: sleetAmount.unit.symbol, type: "sleet")
            case .snow:
                let a = precipitationType.snowfallAmount.minimum.converted(to: Helper.getUnitPrecipitation())
                let b = precipitationType.snowfallAmount.maximum.converted(to: Helper.getUnitPrecipitation())
                let c = precipitationType.snowfallAmount.amount.converted(to: Helper.getUnitPrecipitation())

                if a.value < 1 || b.value < 1 || c.value < 1 {
                    let minimum = Helper.convertNumberToTwoFloatingPoints(number: a.value)
                    let maximum = Helper.convertNumberToTwoFloatingPoints(number: b.value)
                    let amount = Helper.convertNumberToTwoFloatingPoints(number: c.value)
                    if maximum != minimum {
                        return "\(minimum)-\(maximum) \(b.unit.symbol) of snow."
                    }
                    return "About \(amount) \(b.unit.symbol) of snow."
                } else {
                    let minimum = Helper.convertNumberToZeroFloatingPoints(number: a.value)
                    let maximum = Helper.convertNumberToZeroFloatingPoints(number: b.value)
                    let amount = Helper.convertNumberToZeroFloatingPoints(number: c.value)
                    
                    if maximum != minimum {
                        return "\(minimum)-\(maximum) \(b.unit.symbol) of snow."
                    }
                    return "About \(amount) \(b.unit.symbol) of snow."
                }
                
            @unknown default:
                return "Unknown precipitation."
            }
        } else {
            return "nil precipitation"
        }
        
    }

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
        
    var backgroundColor: Color {
        let condition = condition
        return Helper.backgroundColor(weatherCondition: condition)
    }
    
    var scene: SKScene? {
        let condition = condition
        return Helper.getScene(weatherCondition: condition)
    }
}

