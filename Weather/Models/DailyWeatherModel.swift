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
    let precipitationChance: Double // value between 0 and 1
    let snowfallAmount: Measurement<UnitLength>
    let moonEvents: MoonEvents? //TODO: create a MoonEvents object
    let sunData: SunData
    let tomorrowWind: WindData
    let date: Date
    let condition: WeatherCondition
    let uvIndexValue: Int
    let uvIndexCategory: UVIndex.ExposureCategory
    let symbolName: String
    let precipitationAmount: Measurement<UnitLength>
    
    let dayDetails: DetailsModel
    let hourlyWeather: [HourlyModel]
    let timezone: Int

    
    var readableDate: String {
        return getDayOfWeekAndDate(date: date, timezoneOffset: timezone)
    }
    
    var dayHigh: String {
        let temperature = highTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var dayLow: String {
        let temperature = lowTemperature.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: temperature.value)
        return temperatureValueOnly
    }
    
    var precipitationType: String {
        precipitation.description
    }
    
    var dayChanceOfPrecipitation: String {
        precipitationChance.formatted(.percent)
    }
    
    //snowfallAmount
    //rainfallAmount
    //moon events
    
    var dayWeatherDescription: String {
        condition.description
    }
    
    var uvIndexNumber: String {
        uvIndexValue.description
    }
    
    var uvIndexCategoryType: String {
        uvIndexCategory.description
    }
    
    //precipitationAmount
        
 
    var backgroundColor: Color {
        K.getBackGroundColor(symbol: symbolName)
    }
    
    var scene: SKScene? {
        return  K.getScene(symbol: symbolName)
    }
    

    
    static let placeholder = DailyWeatherModel(
        highTemperature: Measurement(value: 50, unit: .fahrenheit),
        lowTemperature: Measurement(value: 50, unit: .fahrenheit),
        precipitation: Precipitation.hail,
        precipitationChance: 0.5,
        snowfallAmount:  Measurement(value: 0.5, unit: .centimeters),
        moonEvents: nil,
        sunData: SunData.sunDataHolder,
        tomorrowWind: WindData.windDataHolder[0],
        date: Date.distantFuture,
        condition: .blizzard,
        uvIndexValue: 5,
        uvIndexCategory: .extreme,
        symbolName: "cloud.rain",
        precipitationAmount: Measurement(value: 0.5, unit: .centimeters),
        dayDetails: DetailsModel.detailsDataHolder,
//        tomorrowHourlyWind: WindData.windDataHolder,
        hourlyWeather: HourlyModel.hourlyTempHolderData,
        timezone: 0
    )
}


extension DailyWeatherModel {
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    private func getDayOfWeekAndDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
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
}
