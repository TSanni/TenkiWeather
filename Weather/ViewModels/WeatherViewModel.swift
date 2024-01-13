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
    @Published var tomorrowWeather: TomorrowWeatherModel = TomorrowWeatherModel.tomorrowDataHolder
    @Published var dailyWeather: [DailyWeatherModel] = DailyWeatherModel.dailyDataHolder
    @Published var weatherAlert: WeatherAlertModel? = nil
    
    @Published var savedLocationsCurrentWeather: [TodayWeatherModel] = [TodayWeatherModel.holderData]
    
    @Published var localTemp = ""
    @Published var localsfSymbol = ""
    @Published var localName = ""
    
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
                let a = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                
                await MainActor.run {
                    localTemp = a.currentTemperature
                    localsfSymbol = a.symbol
                    localName = name
                    print("TIME: \(a.date)")
                }
            }
        } catch {
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }

        }
    }

}
