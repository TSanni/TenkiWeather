//
//  WeatherKitManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation
import WeatherKit

class WeatherKitManager: ObservableObject {
     var weather: Weather?
    
    @Published var currentWeather: TodayWeatherModel = TodayWeatherModel.holderData
    
    
    func getWeather() async {
        do {
            
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181)) // Cupertino?
            weather = try await WeatherService.shared.weather(for: .init(latitude: 43.062096, longitude: 141.354370)) // Sapporo Japan
            await getTodayWeather()
            
//            weather = try await Task.detached(priority: .userInitiated) {
//                // Coordinates for Apple Park just as example coordinates
//                return try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181))
//            }.value
        } catch {
            fatalError("\(error)")
        }
    }
    
    
    
    func getTodayWeather() async {
        
        guard let current = weather?.currentWeather else { return }
        guard let dailyWeather = weather?.dailyForecast else { return }
        
        let currentDetailsCardInfo = CurrentDetails(
            humidity: current.humidity.formatted(.percent).description,
            dewPoint: current.dewPoint.converted(to: .fahrenheit).formatted().description,
            pressure: current.pressure.converted(to: .inchesOfMercury).formatted().description,
            uvIndex: (current.uvIndex.category.description) + ", " + (current.uvIndex.value.description),
            visibility: current.visibility.converted(to: .miles).formatted().description
        )
        
        await MainActor.run(body: {
            self.currentWeather = TodayWeatherModel(
                date: current.date.formatted(date: .abbreviated, time: .complete).description,
                todayHigh: dailyWeather[0].highTemperature.formatted().description,
                todayLow: dailyWeather[0].lowTemperature.formatted().description,
                currentTemperature: current.temperature.formatted().description,
                feelsLikeTemperature: current.apparentTemperature.formatted().description,
                symbol: current.symbolName,
                weatherDescription: dailyWeather[0].condition.description ,
                chanceOfPrecipitation: dailyWeather[0].precipitationChance.formatted(.percent).description,
                currentDetails: currentDetailsCardInfo
            )
        })
        
        print("Sapporo Visibity: \(current.visibility.converted(to: .kilometers).formatted())")
        print("Metadata: \(current.metadata)")
    }
    

}
