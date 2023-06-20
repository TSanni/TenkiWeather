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
        switch symbol {
            case K.Symbol.sunMax:
                return Color(uiColor: K.Colors.clearDay)
            case K.Symbol.moon:
                return Color(uiColor: K.Colors.nighttimePurple)
            case K.Symbol.moonStars:
                return Color(uiColor: K.Colors.nighttimePurple)
            case K.Symbol.cloudSun:
                return Color(uiColor: K.Colors.dayTimeCloudy)
            case K.Symbol.cloudMoon:
                return Color(uiColor: K.Colors.nighttimeCloudy)
            case K.Symbol.cloud:
                return Color(uiColor: K.Colors.cloudy)
            case K.Symbol.cloudRain:
                return Color(uiColor: K.Colors.dayTimeRain)
            case K.Symbol.cloudSunRain:
                return Color(uiColor: K.Colors.dayTimeRain) //
            case K.Symbol.cloudMoonRain:
                return Color(uiColor: K.Colors.dayTimeRain) //
            case K.Symbol.cloudBolt:
                return Color(uiColor: K.Colors.scatteredThunderstorm)
            case K.Symbol.snowflake:
                return Color(uiColor: K.Colors.dayTimeCloudy) //
            case K.Symbol.cloudFog:
                return Color(uiColor: K.Colors.cloudy)
            case K.Symbol.cloudBoltRain:
                return Color(uiColor: K.Colors.thunderstorm)
                
                
                
            default:
                return Color(uiColor: K.Colors.clearDay)
        }
    }
    
    
//    var iconColor: [Color] {
//        switch symbol {
//            case K.WeatherCondition.sunMax:
//                return [.yellow, .yellow, .yellow]
//            case K.WeatherCondition.moonStars:
//                return [K.Colors.moonColor, K.Colors.offWhite, .clear]
//            case "cloud.sun":
//                return [K.Colors.offWhite, .yellow, .clear]
//
//
////                static let sunMax = "sun.max"
////                static let moonStars = "moon.stars"
////                static let cloudSun = "cloud.sun"
////                static let cloudMoon = "cloud.moon"
////                static let cloud = "cloud"
////                static let cloudRain = "cloud.rain"
////                static let cloudSunRain = "cloud.sun.rain"
////                static let cloudMoonRain = "cloud.moon.rain"
////                static let cloudBolt = "cloud.bolt"
////                static let snowflake = "snowflake"
////                static let cloudFog = "cloud.fog"
////                static let sunMin = "sun.min"
////                static let cloudBoltRain = "cloud.bolt.rain"
////                static let cloudDrizzle = "cloud.drizzle"
////                static let cloudSnow = "cloud.snow"
////                static let sunrise = "sunrise"
////                static let sunset = "sunset"
//        }
//    }
    
    
    
    
    /// Takes the name of an SF Symbol icon and returns an array of colors.
    /// Main purpose is to be used with the foregroundStyle modifier
//    func getSFColorForIcon(sfIcon: String) -> [Color] {
//
//        switch sfIcon {
//        case K.WeatherCondition.sunMax:
//            return [.yellow, .yellow, .yellow]
//        case K.WeatherCondition.moonStars:
//            return [K.Colors.moonColor, K.Colors.offWhite, .clear]
//        case K.WeatherCondition.cloudSun:
//            return [K.Colors.offWhite, .yellow, .clear]
//        case K.WeatherCondition.cloudMoon:
//            return [K.Colors.offWhite, K.Colors.moonColor, .clear]
//        case K.WeatherCondition.cloud:
//            return [K.Colors.offWhite, K.Colors.offWhite, K.Colors.offWhite]
//        case K.WeatherCondition.cloudRain:
//            return [K.Colors.offWhite, .cyan, .clear]
//        case K.WeatherCondition.cloudSunRain:
//            return [K.Colors.offWhite, .yellow, .cyan]
//        case K.WeatherCondition.cloudMoonRain:
//            return [K.Colors.offWhite, K.Colors.moonColor, .cyan]
//        case K.WeatherCondition.cloudBolt:
//            return [K.Colors.offWhite, .yellow, .clear]
//        case K.WeatherCondition.snowflake:
//            return [K.Colors.offWhite, .clear, .clear]
//        case K.WeatherCondition.cloudFog:
//            return [K.Colors.offWhite, .gray, .clear]
//            case K.WeatherCondition.cloudBoltRain:
//                return [K.Colors.offWhite, .cyan, .white]
//            
//        default:
//            print("Error getting color")
//                return [.white, .white, .white]
//        }
//    }

    
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
        hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], temperatureUnit: "F"

    )
    
}
