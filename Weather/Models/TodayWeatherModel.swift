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
    let hourlyWeather: [HourlyWeatherModel]
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
        condition: .clear,
        date: Date.now,
        isDaylight: true,
        uvIndexCategory: .extreme,
        uvIndexValue: 10,
        visibility: Measurement(value: 5000, unit: .meters),
        symbolName: "sun.max",
        highTemperature: Measurement(value: 50, unit: .fahrenheit),
        lowTemperature: Measurement(value: 50, unit: .fahrenheit),
        precipitationChance: 0.5,
        sunData: SunData.sunDataHolder,
        hourlyWeather: HourlyWeatherModel.hourlyTempHolderData,
        timezeone: 0
    )
    
}


// MARK: - Computed Properties
extension TodayWeatherModel {
    var feelsLikeTemperature: String {
        let temperature = apparentTemperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var dewPointDescription: String {
        let dewPointTemperature = dewPoint.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: dewPointTemperature.value)
        let description = "The dew point is " + temperatureValueOnly + dewPointTemperature.unit.symbol + " right now."
        return description
    }
    
    var humidityPercentage: String {
        humidity.formatted(.percent)
    }
    
    var currentTemperature: String {
        let temperature = temperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var pressureString: String {
        let pressure = pressure.converted(to: .inchesOfMercury)
        let value = Helper.convertNumberToTwoFloatingPoints(number: pressure.value)
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
        return Helper.getReadableMainDate(date: date, timezoneOffset: timezeone)
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
        let unit = Helper.getUnitLength()
        let visibility = visibility.converted(to: unit)
        let formattedVisibilityValue = Helper.convertNumberToZeroFloatingPoints(number: visibility.value)
        let symbol = visibility.unit.symbol
        return formattedVisibilityValue + " " + symbol
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
        let temperature = highTemperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var todayLow: String {
        let temperature = lowTemperature.converted(to: Helper.getUnitTemperature())
        let temperatureValueOnly = Helper.convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var backgroundColor: Color {
        let condition = condition
        let isDaylight = isDaylight
        return Helper.backgroundColor(weatherCondition: condition, isDaylight: isDaylight)
    }
    
    var scene: SKScene? {
        let condition = condition
        return Helper.getScene(weatherCondition: condition)
    }
}

