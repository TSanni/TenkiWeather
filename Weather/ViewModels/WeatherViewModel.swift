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
    @Published var showErrorAlert = false
    @Published var currentError: WeatherErrors? = nil
    @Published private(set) var lastUpdated: String = ""

    private let weatherManager: WeatherManager


    init(weatherManager: WeatherManager = WeatherManager.shared) {
        self.weatherManager = weatherManager
    }
    
    private func setLastUpdated() {
        self.lastUpdated = Helper.getReadableMainDate(date: Date.now, timezoneOffset: TimeZone.current.secondsFromGMT())
    }
    
    func fetchWeather(latitude: Double, longitude: Double, timezone: Int) async {
        do {
            let weather = try await weatherManager.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezone: timezone)
            
            let currentWeather = weatherManager.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
            
            let tomorrowWeather = weatherManager.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: timezone)
            
            let dailyWeather = weatherManager.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
            
            let weatherAlert = weatherManager.getWeatherAlert(optionalWeatherAlert: weather.weatherAlerts)
            
            await MainActor.run {
                self.currentWeather = currentWeather
                self.tomorrowWeather = tomorrowWeather
                self.dailyWeather = dailyWeather
                self.weatherAlert = weatherAlert
                setLastUpdated()
            }
            
            
        } catch {
            await MainActor.run {
                currentError = .failedToGetWeatherKitData
                showErrorAlert.toggle()
            }
        }
    }
    
    func fetchLocalWeather(latitude: Double, longitude: Double, name: String, timezone: Int) async {
        do {
            let weather = try await weatherManager.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezone: timezone)
            
            let localWeather = weatherManager.getTodayWeather(
                current: weather.currentWeather,
                dailyWeather: weather.dailyForecast,
                hourlyWeather: weather.hourlyForecast,
                timezoneOffset: timezone
            )
            
            await MainActor.run {
                self.localWeather = localWeather
                setLastUpdated()
            }
        } catch {
            await MainActor.run {
                currentError = .failedToGetWeatherKitData
                showErrorAlert.toggle()
            }
        }
    }
}
