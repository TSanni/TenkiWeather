//
//  TomorrowWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/9/23.
//

import Foundation
import WeatherKit
import SwiftUI

//MARK: - Main Model
struct TomorrowWeatherModel: Identifiable {
    let id = UUID()
    let date: String
    let tomorrowLow: String
    let tomorrowHigh: String
    let tomorrowSymbol: String
    let tomorrowWeatherDescription: WeatherCondition
    let tomorrowChanceOfPrecipitation: String
    
    let tomorrowDetails: DetailsModel
    let tomorrowWind: WindData
    let tomorrowHourlyWind: [WindData]
    let hourlyTemperatures: [HourlyTemperatures]
    
    
    
    var backgroundColor: Color {
        switch tomorrowSymbol {
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

    
    /// Holder data for tomorrow's weather
    static let tomorrowDataHolder = TomorrowWeatherModel(
        date: "-",
        tomorrowLow: "-",
        tomorrowHigh: "-",
        tomorrowSymbol: "-",
        tomorrowWeatherDescription: .clear,
        tomorrowChanceOfPrecipitation: "-",
        tomorrowDetails: DetailsModel.detailsDataHolder,
        tomorrowWind: WindData.windDataHolder,
        tomorrowHourlyWind: [WindData.windDataHolder],
        hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData]
    )
}
