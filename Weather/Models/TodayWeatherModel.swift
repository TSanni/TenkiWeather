//
//  TodayWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation
import WeatherKit
import SwiftUI
//MARK: - Main Model
struct TodayWeatherModel: Identifiable {
    let id = UUID()
    let date: String
    let todayHigh: String
    let todayLow: String
    let currentTemperature: String
    let feelsLikeTemperature: String
    let symbol: String
    let weatherDescription: WeatherCondition
    let chanceOfPrecipitation: String
    let currentDetails: DetailsModel
    let todayWind: WindData
    let todayHourlyWind: [WindData]
    let sunData: SunData
    let isDaylight: Bool
    let hourlyTemperatures: [HourlyTemperatures]
    let temperatureUnit: String
    
    
    
    var backgroundColor: Color {
        
        K.getBackGroundColor(symbol: symbol)
        
//        switch symbol {
//            case K.Symbol.sunMax:
//                return Color(uiColor: K.Colors.clearDay)
//            case K.Symbol.moon:
//                return Color(uiColor: K.Colors.nighttimePurple)
//            case K.Symbol.moonStars:
//                return Color(uiColor: K.Colors.nighttimePurple)
//            case K.Symbol.cloudSun:
//                return Color(uiColor: K.Colors.dayTimeCloudy)
//            case K.Symbol.cloudMoon:
//                return Color(uiColor: K.Colors.nighttimeCloudy)
//            case K.Symbol.cloud:
//                return Color(uiColor: K.Colors.cloudy)
//            case K.Symbol.cloudRain:
//                return Color(uiColor: K.Colors.dayTimeRain)
//            case K.Symbol.cloudSunRain:
//                return Color(uiColor: K.Colors.dayTimeRain) //
//            case K.Symbol.cloudMoonRain:
//                return Color(uiColor: K.Colors.dayTimeRain) //
//            case K.Symbol.cloudBolt:
//                return Color(uiColor: K.Colors.scatteredThunderstorm)
//            case K.Symbol.snowflake:
//                return Color(uiColor: K.Colors.dayTimeCloudy) //
//            case K.Symbol.cloudFog:
//                return Color(uiColor: K.Colors.cloudy)
//            case K.Symbol.cloudBoltRain:
//                return Color(uiColor: K.Colors.thunderstorm)
//
//
//
//            default:
//                return Color(uiColor: K.Colors.clearDay)
//        }
    }
    


    
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        date: "July 7, 2077",
        todayHigh: "777",
        todayLow: "777",
        currentTemperature: "1000",
        feelsLikeTemperature: "1000",
        symbol: "sun.min",
        weatherDescription: .clear,
        chanceOfPrecipitation: "1000%",
        currentDetails: DetailsModel.detailsDataHolder,
        todayWind: WindData.windDataHolder,
        todayHourlyWind: [WindData.windDataHolder],
        sunData: SunData.sunDataHolder,
        isDaylight: false,
        hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData],
        temperatureUnit: "F"

    )
    
}
