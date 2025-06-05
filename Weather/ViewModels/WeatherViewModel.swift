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

    private let weatherManager: WeatherServiceProtocol


    init(weatherManager: WeatherServiceProtocol) {
        self.weatherManager = weatherManager
    }
    
    private func setLastUpdated() {
        self.lastUpdated = Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: TimeZone.current.identifier)
    }
    
    func fetchWeather(latitude: Double, longitude: Double, timezoneIdentifier: String) async {
        do {
            let weather = try await weatherManager.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezoneIdentifier: timezoneIdentifier)
            
            let currentWeather = weatherManager.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
            let tomorrowWeather = weatherManager.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
            let dailyWeather = weatherManager.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneIdentifier: timezoneIdentifier)
            
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
    
    func fetchLocalWeather(latitude: Double, longitude: Double, name: String, timezoneIdentifier: String) async {
        do {
            let weather = try await weatherManager.fetchWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezoneIdentifier: timezoneIdentifier)
            
            let localWeather = weatherManager.getTodayWeather(
                current: weather.currentWeather,
                dailyWeather: weather.dailyForecast,
                hourlyWeather: weather.hourlyForecast,
                timezoneIdentifier: timezoneIdentifier
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
