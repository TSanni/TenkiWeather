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

    
    static let hourlyTempHolderData = HourlyTemperatures(temperature: "77", date: "700", symbol: "sun.min", chanceOfPrecipitation: "777%")
}
