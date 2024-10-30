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
    
    static let shared = WeatherViewModel()
    
    let weatherManager = WeatherManager.shared
    
    private init() { }
    
    func getWeather(latitude: Double, longitude: Double, timezone: Int) async {
        do {
            let weather = try await weatherManager.getWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezone: timezone)
            
            if let weather = weather {
                
                let currentWeather = await weatherManager.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                
                let tomorrowWeather = await weatherManager.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: timezone)

                let dailyWeather = await weatherManager.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                
                let weatherAlert = await weatherManager.getWeatherAlert(optionalWeatherAlert: weather.weatherAlerts)

                await MainActor.run {
                    self.currentWeather = currentWeather
                    self.tomorrowWeather = tomorrowWeather
                    self.dailyWeather = dailyWeather
                    self.weatherAlert = weatherAlert
                }
            }
        } catch {
            await MainActor.run {
                currentError = .failedToGetWeatherKitData
                showErrorAlert.toggle()
            }
        }
    }

    func getLocalWeather(latitude: Double, longitude: Double, name: String, timezone: Int) async {
        do {
            let weather = try await weatherManager.getWeatherFromWeatherKit(latitude: latitude, longitude: longitude, timezone: timezone)
            
            if let weather = weather {
                let localWeather = await weatherManager.getTodayWeather(
                    current: weather.currentWeather,
                    dailyWeather: weather.dailyForecast,
                    hourlyWeather: weather.hourlyForecast,
                    timezoneOffset: timezone
                )
                
                await MainActor.run {
                    self.localWeather = localWeather
                }
            }
        } catch {
            await MainActor.run {
                currentError = .failedToGetWeatherKitData
                showErrorAlert.toggle()
            }
        }
    }
}
