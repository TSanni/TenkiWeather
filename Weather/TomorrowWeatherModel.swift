//
//  TomorrowWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/9/23.
//

import Foundation

//MARK: - Main Model
struct TomorrowWeatherModel: Identifiable {
    let id = UUID()
    let date: String
    let tomorrowLow: String
    let tomorrowHigh: String
    let tomorrowSymbol: String
    let tomorrowWeatherDescription: String
    let tomorrowChanceOfPrecipitation: String
    
    let tomorrowDetails: DetailsModel
    let tomorrowWind: WindData
    let tomorrowHourlyWind: [WindData]
    
    /// Holder data for tomorrow's weather
    static let tomorrowDataHolder = TomorrowWeatherModel(
        date: "-",
        tomorrowLow: "-",
        tomorrowHigh: "-",
        tomorrowSymbol: "-",
        tomorrowWeatherDescription: "-",
        tomorrowChanceOfPrecipitation: "-",
        tomorrowDetails: DetailsModel.detailsDataHolder,
        tomorrowWind: WindData.windDataHolder,
        tomorrowHourlyWind: [WindData.windDataHolder]
    )
}



//MARK: - Tomorrow Details Model : Will be part of main model
//struct TomorrowDetails {
//    let uvIndex: String
//    let sunData: SunData
//    // let humidity: String // Not available in WeatherKit
//    // let dewPoint: String // Not available in WeatherKit
//    // let pressure: String // Not availble in WeatherKit
//    // let visibility: String // Not available in WeatherKit
//
//    /// Holder data for tomorrow's details
//    static let tomorrowDetailsHolder = TomorrowDetails(uvIndex: "-", sunData: SunData.sunDataHolder)
//}
