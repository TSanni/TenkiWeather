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
    @Published var dailyWeather: [DailyWeatherModel] = [DailyWeatherModel.dailyDataHolder]
    
    @Published var savedLocationsCurrentWeather: [TodayWeatherModel] = [TodayWeatherModel.holderData]
    
    @Published var localTemp = ""
    @Published var localsfSymbol = ""
    @Published var localName = ""
    
    func getWeather(latitude: Double, longitude: Double) async {
        
        do {
            let (weather, timezone) = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude)
            
            if let weather = weather {
                await MainActor.run(body: {
                    self.currentWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                    self.tomorrowWeather = WeatherManager.shared.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: timezone)
                    self.dailyWeather = WeatherManager.shared.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                })
            }
            
            
        } catch {
            fatalError("Unable to get wather data. Check WeatherViewModel")
        }
        
    }
    
    
    
    func getLocalWeather(latitude: Double, longitude: Double, name: String) async {
        do {
            let (weather, timezone) = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude)
            
            if let weather = weather {
                let a = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
//                let b = await GeocodingManager.shared.performRevereseGeocoding(lat: latitude, lon: longitude)
                await MainActor.run {
                    localTemp = a.currentTemperature
                    localsfSymbol = a.symbol
                    localName = name
                    
//                    if let c = b {
//                    }
                }
            }
            
            

            
        } catch {
            fatalError("Unable to get wather data. Check WeatherViewModel")
        }
    }
    
    
    
}
