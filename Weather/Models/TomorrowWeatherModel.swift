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
    let tomorrowChanceOfPrecipitation: Double
    
    let tomorrowDetails: DetailsModel
    let tomorrowWind: WindData
    let tomorrowHourlyWind: [WindData]
    let hourlyTemperatures: [HourlyTemperatures]
    let sunData: SunData
    let precipitation: Precipitation

    
 
    var backgroundColor: Color {
        K.getBackGroundColor(symbol: tomorrowSymbol)
    }

    
    /// Holder data for tomorrow's weather
    static let tomorrowDataHolder = TomorrowWeatherModel(
        date: "-",
        tomorrowLow: "-",
        tomorrowHigh: "-",
        tomorrowSymbol: "cloud.rain",
        tomorrowWeatherDescription: .clear,
        tomorrowChanceOfPrecipitation: 0.5,
        tomorrowDetails: DetailsModel.detailsDataHolder,
        tomorrowWind: WindData.windDataHolder[0],
        tomorrowHourlyWind: WindData.windDataHolder,
        hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData, sunData: SunData.sunDataHolder, precipitation: Precipitation.hail
    )
}
