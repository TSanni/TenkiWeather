//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit

class WeatherViewModel: ObservableObject {
    @Published private(set) var currentWeather: TodayWeatherModel = TodayWeatherModelPlaceHolder.holderData
    @Published private(set) var tomorrowWeather: DailyWeatherModel = DailyWeatherModelPlaceHolder.placeholder
    @Published private(set) var dailyWeather: [DailyWeatherModel] = DailyWeatherModelPlaceHolder.placeholderArray
    @Published private(set) var weatherAlert: WeatherAlertModel? = nil
    @Published private(set) var localWeather: TodayWeatherModel = TodayWeatherModelPlaceHolder.holderData

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }

    func fetchWeather(latitude: Double, longitude: Double, timezoneIdentifier: String) async throws {
        do {
            let weather = try await weatherService.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezoneIdentifier: timezoneIdentifier)
            
            let currentWeather = weatherService.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
            let tomorrowWeather = weatherService.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
            let dailyWeather = weatherService.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
            let weatherAlert = weatherService.getWeatherAlert(optionalWeatherAlert: weather.weatherAlerts)
            
            await MainActor.run {
                self.currentWeather = currentWeather
                self.tomorrowWeather = tomorrowWeather
                self.dailyWeather = dailyWeather
                self.weatherAlert = weatherAlert
            }
        } catch let error {
            throw error
        }
    }
    
    func fetchLocalWeather(latitude: Double, longitude: Double, name: String, timezoneIdentifier: String) async throws {
        do {
            let weather = try await weatherService.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezoneIdentifier: timezoneIdentifier)
            
            let localWeather = weatherService.getTodayWeather(
                current: weather.currentWeather,
                dailyWeather: weather.dailyForecast,
                hourlyWeather: weather.hourlyForecast,
                timezoneIdentifier: timezoneIdentifier
            )
            
            await MainActor.run {
                self.localWeather = localWeather
            }
        } catch let error {
            throw error
        }
    }
}
