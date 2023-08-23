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
    
    @Published var savedLocationsCurrentWeather: [TodayWeatherModel] = [TodayWeatherModel.holderData]
    
    @Published var localTemp = ""
    @Published var localsfSymbol = ""
    @Published var localName = ""
    
    @Published var errorPublisher: (errorBool: Bool, errorMessage: String) = (false, "")
    
    @Published var loading: Bool = false
    
    func getWeather(latitude: Double, longitude: Double, timezone: Int) async {
        
        do {
            await MainActor.run(body: {
                self.loading = true
            })
            let weather = try await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude, timezone: timezone)
            
            if let weather = weather {
                await MainActor.run {
                    self.currentWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                    self.tomorrowWeather = WeatherManager.shared.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: timezone)
                    self.dailyWeather = WeatherManager.shared.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                }
            }
            
            await MainActor.run(body: {
                self.loading = false

            })
            
            
        } catch {
            print(error.localizedDescription)
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }
            //            fatalError("Unable to get wather data. Check WeatherViewModel")
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
                }
            }
        } catch {
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }

//            fatalError("Unable to get wather data. Check WeatherViewModel")
        }
    }

}
