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
    let wind: WindModel
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
    let sunData: SunModel
    let hourlyWeather: [HourlyWeatherModel]
    let timezeone: Int
}


// MARK: - Computed Properties
extension TodayWeatherModel {
    
    func areSymbolsEqual(symbol1: String, symbol2: String) -> Bool {
        if symbol1 == symbol2 {
            return true
        } else {
            return false
        }
        
        
    }
    
    func forecastSentence1(currentHour: HourlyWeatherModel, comparedHour: HourlyWeatherModel) -> String? {
        if areSymbolsEqual(symbol1: currentHour.symbol, symbol2: comparedHour.symbol) {
            return nil
        }
        
        let currentDay = Helper.getDayOfWeekAndDate(date: currentHour.date, timezoneOffset: timezeone)
        let comparedDay = Helper.getDayOfWeekAndDate(date: comparedHour.date, timezoneOffset: timezeone)
        
        if currentDay == comparedDay {
            let dayOrNight = comparedHour.isDayLight ? "today" : "tonight"
            return "\(comparedHour.condition.description) expected around \(comparedHour.readableDate) \(dayOrNight)."
        } else {
            return "\(comparedHour.condition.description) expected around \(comparedHour.readableDate) tomorrow."

        }
    }
    
    func forecastSentence2(currentHour: HourlyWeatherModel, comparedHour: HourlyWeatherModel) -> String? {
        if areSymbolsEqual(symbol1: currentHour.symbol, symbol2: comparedHour.symbol) {
            return nil
        }
        let currentDay = Helper.getDayOfWeekAndDate(date: currentHour.date, timezoneOffset: timezeone)
        let comparedDay = Helper.getDayOfWeekAndDate(date: comparedHour.date, timezoneOffset: timezeone)
        
        if currentDay == comparedDay {
            let dayOrNight = comparedHour.isDayLight ? "today" : "tonight"
            return "\(comparedHour.condition.description) conditions expected around \(comparedHour.readableDate) \(dayOrNight)."
        } else {
            return "\(comparedHour.condition.description) conditions expected around \(comparedHour.readableDate) tomorrow."

        }
    }

    
    var getForecastUsingHourlyWeather: String? {
        let currentHour = hourlyWeather[0]
        let dayOrNight = currentHour.isDayLight ? "day" : "night"

        for i in 1..<hourlyWeather.count {
            if hourlyWeather[i].condition != currentHour.condition {
                
                switch hourlyWeather[i].condition {
                case .blizzard, .blowingDust, .blowingSnow, .drizzle, .flurries, .freezingDrizzle, .freezingRain, .hail, .haze, .heavyRain, .heavySnow, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .sleet, .snow, .strongStorms, .thunderstorms, .tropicalStorm:
                    return forecastSentence1(currentHour: currentHour, comparedHour: hourlyWeather[i])
                    
                case .breezy, .clear, .cloudy, .foggy, .frigid, .hot, .mostlyClear, .mostlyCloudy, .partlyCloudy, .smoky, .sunFlurries, .sunShowers, .windy, .wintryMix:
                    return forecastSentence2(currentHour: currentHour, comparedHour: hourlyWeather[i])
                @unknown default:
                    return nil
                }  
            }
        }
        
        switch currentHour.condition {
        case .blizzard, .blowingDust, .blowingSnow, .drizzle, .flurries, .freezingDrizzle, .freezingRain, .hail, .haze, .heavyRain, .heavySnow, .hurricane, .isolatedThunderstorms, .rain, .scatteredThunderstorms, .sleet, .snow, .strongStorms, .thunderstorms, .tropicalStorm:
            
            return "\(currentHour.condition.description) will continue for the rest of the \(dayOrNight)."
            
            
        case .breezy, .clear, .cloudy, .foggy, .frigid, .hot, .mostlyClear, .mostlyCloudy, .partlyCloudy, .smoky, .sunFlurries, .sunShowers, .windy, .wintryMix:
            
            return "\(currentHour.condition.description) conditions will continue for the rest of the \(dayOrNight)."
        @unknown default:
            return nil
        }
        
    }
    
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

