//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var tomorrowWeather: DailyWeatherModel = DailyWeatherModel.placeholder
    @Published var dailyWeather: [DailyWeatherModel] = [DailyWeatherModel.placeholder]
    @Published var weatherAlert: WeatherAlertModel? = nil
    
    @Published var savedLocationsCurrentWeather: [TodayWeatherModel] = [TodayWeatherModel.holderData]
    
    @Published var localTemp = ""
    @Published var localsfSymbol = ""
    @Published var localName = ""
    @Published var localConditions = ""
    
    @Published var errorPublisher: (errorBool: Bool, errorMessage: String) = (false, "")
    
    
    func getWeather(latitude: Double, longitude: Double, timezone: Int) async {
        
        do {
        
            let weather = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude, timezone: timezone)

            
            if let weather = weather {
                await MainActor.run {
                    self.currentWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                    self.tomorrowWeather = WeatherManager.shared.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: timezone)
                    self.dailyWeather = WeatherManager.shared.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                    
                    self.weatherAlert = WeatherManager.shared.getWeatherAlert(optionalWeatherAlert: weather.weatherAlerts)
                }
            }    
        } catch {
            print(error.localizedDescription)
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }
        }
    }
    
    
    
    func getLocalWeather(latitude: Double, longitude: Double, name: String, timezone: Int) async {
        do {
            let weather = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude, timezone: timezone)
            
            if let weather = weather {
                let localWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                
                await MainActor.run {
                    localTemp = localWeather.currentTemperature
                    localsfSymbol = localWeather.symbol
                    localName = name
                    localConditions = localWeather.weatherDescription.description
                }
            }
        } catch {
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }

        }
    }

}
