//
//  TodayWeatherModel+placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/3/24.
//

import Foundation


struct TodayWeatherModelPlaceHolder {
    /// Holder data for Today's weather
    static let holderData = TodayWeatherModel(
        apparentTemperature:  Measurement(value: 77, unit: .fahrenheit),
        dewPoint: Measurement(value: 77, unit: .fahrenheit),
        humidity: 0.5,
        temperature: Measurement(value: 77, unit: .fahrenheit),
        pressure: Measurement(value: 0, unit: .inchesOfMercury),
        pressureTrend: .steady,
        wind: WindModelPlaceholder.windDataHolder[0],
        condition: .clear,
        date: Date.now,
        isDaylight: true,
        uvIndexCategory: .low,
        uvIndexValue: 3,
        visibility: Measurement(value: 7, unit: .miles),
        symbolName: "sun.max",
        highTemperature: Measurement(value: 100, unit: .fahrenheit),
        lowTemperature: Measurement(value: 0, unit: .fahrenheit),
        precipitationChance: 0.8,
        sunData: SunModelPlaceholder.sunDataHolder,
        hourlyWeather: HourlyWeatherModelPlaceholder.hourlyTempHolderDataArray,
        timezeone: 0,
        moonData: MoonModelPlaceholder.moonDataHolder
    )
}
