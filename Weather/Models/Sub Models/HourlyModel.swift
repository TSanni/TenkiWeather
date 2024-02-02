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
        HourlyTemperatures(temperature: "50", date: "12 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "1 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "2 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "80", date: "3 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "40", date: "4 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "80", date: "5 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "6 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "7 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "30", date: "8 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "9 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "80", date: "10 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "40", date: "11 AM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "12 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "1 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "2 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "3 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "80", date: "4 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "5 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "6 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "70", date: "7 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "40", date: "8 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "40", date: "9 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "10 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),
        HourlyTemperatures(temperature: "50", date: "11 PM", symbol: "sun.max", chanceOfPrecipitation: "0%"),

    ]
}





