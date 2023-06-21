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
    

    func getWeather(latitude: Double, longitude: Double) async {
        guard let weatherAndTimeZone = try? await WeatherManager.shared.getWeather(latitude: latitude, longitude: longitude) else {
            fatalError("Unable to get wather data. Check WeatherViewModel")
        }
        
        if let weather = weatherAndTimeZone.0 {
            await MainActor.run(body: {
                self.currentWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: weatherAndTimeZone.1)
                self.tomorrowWeather = WeatherManager.shared.getTomorrowWeather(tomorrowWeather: weather.dailyForecast, hours: weather.hourlyForecast, timezoneOffset: weatherAndTimeZone.1)
                self.dailyWeather = WeatherManager.shared.getDailyWeather(dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: weatherAndTimeZone.1)
            })
        }
        
        


    }
    
    

}
