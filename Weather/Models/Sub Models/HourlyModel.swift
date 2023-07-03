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

    
    static let hourlyTempHolderData = HourlyTemperatures(temperature: "-", date: "-", symbol: "sun.min", chanceOfPrecipitation: "-")
}
