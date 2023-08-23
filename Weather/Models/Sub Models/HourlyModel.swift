//
//  HourlyModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

/// Consists of temperatures and the dates
struct HourlyTemperatures: Identifiable {
    let id = UUID()
    let temperature: String
    let date: String
    let symbol: String
    let chanceOfPrecipitation: String

    
    static let hourlyTempHolderData: [HourlyTemperatures] = [
        HourlyTemperatures(temperature: "0", date: "12 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "20", date: "1 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "30", date: "2 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "40", date: "3 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "50", date: "4 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "40", date: "5 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "30", date: "6 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "20", date: "7 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "10", date: "8 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),
        HourlyTemperatures(temperature: "5", date: "9 AM", symbol: "sun.max", chanceOfPrecipitation: "10%"),

    ]
}





