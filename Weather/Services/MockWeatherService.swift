//
//  MockWeatherService.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/3/25.
//

import Foundation
import WeatherKit

class MockWeatherService: WeatherServiceProtocol {
    
    var shouldFail = false
    
    func fetchWeatherFromWeatherKit(latitude: Double, longitude: Double, timezoneIdentifier: String) async throws -> Weather {
        if shouldFail {
            throw WeatherErrors.failedToGetWeatherKitData
        }
        
        do {
            let weather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            return weather
        } catch {
            throw WeatherErrors.failedToGetWeatherKitData
        }
    }
    
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> TodayWeatherModel {
        return TodayWeatherModelPlaceHolder.holderData
    }
    
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneIdentifier: String) -> DailyWeatherModel {
        return DailyWeatherModelPlaceHolder.placeholder
    }
    
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> [DailyWeatherModel] {
        DailyWeatherModelPlaceHolder.placeholderArray
    }
    
    func getWeatherAlert(optionalWeatherAlert: [WeatherAlert]?) -> WeatherAlertModel? {
        WeatherAlertModelPlaceholder.weatherAlertHolder
    }
    
    
}
