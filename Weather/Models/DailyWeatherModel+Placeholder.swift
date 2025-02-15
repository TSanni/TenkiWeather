//
//  DailyWeatherModel+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/4/24.
//

import Foundation
import WeatherKit


struct DailyWeatherModelPlaceHolder {
    static let placeholder = DailyWeatherModel(
        highTemperature: Measurement(value: 0, unit: .fahrenheit),
        lowTemperature: Measurement(value: 0, unit: .fahrenheit),
        precipitation: Precipitation.hail,
        precipitationChance: 0,
        moon: nil,
        sun: SunModelPlaceholder.sunDataHolder,
        wind: WindModelPlaceholder.windDataHolder[0],
        date: Date.distantFuture,
        condition: .rain,
        uvIndexValue: 0,
        uvIndexCategory: .extreme,
        symbolName: "cloud.rain",
        hourlyWeather: HourlyWeatherModelPlaceholder.hourlyTempHolderDataArray,
        timezone: 0,
        precipitationAmountByType: nil
    )
    
    
    
    static let placeholderArray: [DailyWeatherModel] = [
        placeholder, 
        placeholder,
        placeholder,
        placeholder,
        placeholder,
        placeholder,
        placeholder,
        placeholder,
        placeholder,
        placeholder,
    ]
}
