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
    }
    


    
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        date: "-",
        todayHigh: "-",
        todayLow: "-",
        currentTemperature: "-",
        feelsLikeTemperature: "-",
        symbol: "sun.min",
        weatherDescription: .clear,
        chanceOfPrecipitation: "-",
        currentDetails: DetailsModel.detailsDataHolder,
        todayWind: WindData.windDataHolder[0],
        todayHourlyWind: WindData.windDataHolder,
        sunData: SunData.sunDataHolder,
        isDaylight: false,
        hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData,
        temperatureUnit: ""

    )
    
}
