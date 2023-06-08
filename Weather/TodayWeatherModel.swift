//
//  TodayWeatherModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation

struct TodayWeatherModel: Identifiable {
    let id = UUID()
    let date: String
    let todayHigh: String
    let todayLow: String
    let currentTemperature: String
    let feelsLikeTemperature: String
    let symbol: String
    let weatherDescription: String
    let chanceOfPrecipitation: String
    
    let currentDetails: CurrentDetails
    
    
    
    static let holderData = TodayWeatherModel(date: "-", todayHigh: "-", todayLow: "-", currentTemperature: "-", feelsLikeTemperature: "-", symbol: "-", weatherDescription: "-", chanceOfPrecipitation: "-", currentDetails: CurrentDetails.currentDetailsHolder)
    
}

struct CurrentDetails {
    let humidity: String
    let dewPoint: String
    let pressure: String
    let uvIndex: String
    let visibility: String
    
    static let currentDetailsHolder = CurrentDetails(humidity: "-", dewPoint: "-", pressure: "-", uvIndex: "-", visibility: "-")
}


struct Hi {
    let ab: String
}
