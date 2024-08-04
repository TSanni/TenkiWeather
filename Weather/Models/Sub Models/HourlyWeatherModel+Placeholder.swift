//
//  HourlyWeatherModelPlaceholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/4/24.
//

import Foundation

struct HourlyWeatherModelPlaceholder {
    
    static var hourlyTempHolderDataArray: [HourlyWeatherModel] {
        var arr: [HourlyWeatherModel] = []
        var startingTime = 3600
        for i in 0..<12 {
            arr.append(
                HourlyWeatherModel(
                    temperature: Measurement(value: 0, unit: .fahrenheit),
                    wind: WindModelPlaceholder.windDataHolder[i],
                    date: Date(timeIntervalSince1970: TimeInterval(startingTime)),
                    precipitationChance: 0,
                    symbol: "sun.max",
                    timezone: 0
                )
            )
            startingTime += 3600
        }
        
        return arr
    }
}
