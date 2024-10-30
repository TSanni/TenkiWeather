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
        apparentTemperature:  Measurement(value: 0, unit: .fahrenheit),
        dewPoint: Measurement(value: 0, unit: .fahrenheit),
        humidity: 0,
        temperature: Measurement(value: 0, unit: .fahrenheit),
        pressure: Measurement(value: 0, unit: .inchesOfMercury),
        pressureTrend: .steady,
        wind: WindModelPlaceholder.windDataHolder[0],
        condition: .clear,
        date: Date.now,
        isDaylight: true,
        uvIndexCategory: .extreme,
        uvIndexValue: 0,
        visibility: Measurement(value: 0, unit: .meters),
        symbolName: "sun.max",
        highTemperature: Measurement(value: 0, unit: .fahrenheit),
        lowTemperature: Measurement(value: 0, unit: .fahrenheit),
        precipitationChance: 0,
        sunData: SunModelPlaceholder.sunDataHolder,
        hourlyWeather: HourlyWeatherModelPlaceholder.hourlyTempHolderDataArray,
        timezeone: 0,
        moonData: MoonModelPlaceholder.moonDataHolder
    )
}
