//
//  DailyWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation
import WeatherKit

//MARK: - Main Model for Daily Weather
/// Daily Weather Model - Includes properties for daily weather to be used with WeatherKit
struct DailyWeatherModel: Identifiable {
    let id = UUID()
    
    let date: String
    let dailyWeatherDescription: WeatherCondition
    let dailyChanceOfPrecipitation: String // Will be used twice in daily view
    let dailySymbol: String
    let dailyLowTemp: String
    let dailyHighTemp: String
    
    let dailyWind: WindData
    let dailyUVIndex: String
    let sunEvents: SunData
    let hourlyTemperatures: [HourlyTemperatures]

    
    
    /// Holder data for daily weather
    
    static let dailyDataHolder: [DailyWeatherModel] = [
        DailyWeatherModel(
            date: "-",
            dailyWeatherDescription: .clear,
            dailyChanceOfPrecipitation: "-",
            dailySymbol: "-",
            dailyLowTemp: "-",
            dailyHighTemp: "-",
            dailyWind: WindData.windDataHolder[0],
            dailyUVIndex: "-",
            sunEvents: SunData.sunDataHolder, hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData
        ),
        
        DailyWeatherModel(
            date: "-",
            dailyWeatherDescription: .clear,
            dailyChanceOfPrecipitation: "-",
            dailySymbol: "-",
            dailyLowTemp: "-",
            dailyHighTemp: "-",
            dailyWind: WindData.windDataHolder[0],
            dailyUVIndex: "-",
            sunEvents: SunData.sunDataHolder, hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData
        ),
        
        DailyWeatherModel(
            date: "-",
            dailyWeatherDescription: .clear,
            dailyChanceOfPrecipitation: "-",
            dailySymbol: "-",
            dailyLowTemp: "-",
            dailyHighTemp: "-",
            dailyWind: WindData.windDataHolder[0],
            dailyUVIndex: "-",
            sunEvents: SunData.sunDataHolder, hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData
        )
    ]
    
//    static let dailyDataHolder = DailyWeatherModel(
//        date: "-",
//        dailyWeatherDescription: .clear,
//        dailyChanceOfPrecipitation: "-",
//        dailySymbol: "-",
//        dailyLowTemp: "-",
//        dailyHighTemp: "-",
//        dailyWind: WindData.windDataHolder[0],
//        dailyUVIndex: "-",
//        sunEvents: SunData.sunDataHolder, hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData
//    )
    

}




