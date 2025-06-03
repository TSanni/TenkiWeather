//
//  MockWeatherService.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/3/25.
//

import Foundation
import WeatherKit

class MockWeatherService: WeatherServiceProtocol {
    
    func fetchWeatherFromWeatherKit(latitude: Double, longitude: Double, timezone: Int) async throws -> Weather {
        do {
            let weather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            return weather
        } catch {
            throw WeatherErrors.failedToGetWeatherKitData
        }
    }
    
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> TodayWeatherModel {
        return TodayWeatherModelPlaceHolder.holderData
    }
    
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneOffset: Int) -> DailyWeatherModel {
        return DailyWeatherModelPlaceHolder.placeholder
    }
    
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> [DailyWeatherModel] {
        DailyWeatherModelPlaceHolder.placeholderArray
    }
    
    func getWeatherAlert(optionalWeatherAlert: [WeatherAlert]?) -> WeatherAlertModel? {
        WeatherAlertModelPlaceholder.weatherAlertHolder
    }
    
    
}
