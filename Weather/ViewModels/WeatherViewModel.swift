//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit
import GooglePlaces


class WeatherViewModel: ObservableObject {
    @Published var currentWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var tomorrowWeather: DailyWeatherModel = DailyWeatherModel.placeholder
    @Published var dailyWeather: [DailyWeatherModel] = [DailyWeatherModel.placeholder]
    @Published var weatherAlert: WeatherAlertModel? = nil
    @Published var localWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var errorPublisher: (errorBool: Bool, errorMessage: String) = (false, "")
    
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
            print(error.localizedDescription)
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
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
                errorPublisher = (true, error.localizedDescription)
            }
        }
    }

    /// Takes a CompassDirection and returns a Double which indicates the angle the current compass direction.
    /// One use can be to properly set rotation effects on views
    func getRotation(direction: Wind.CompassDirection) -> Double {
        // starting pointing east. Subtract 90 to point north
        // Think of this as 0 on a pie chart
        let zero: Double = 45

        switch direction {
            case .north:
                return zero - 90
            case .northNortheast:
                return zero - 67.5
            case .northeast:
                return zero - 45
            case .eastNortheast:
                return zero - 22.5
            case .east:
                return zero
            case .eastSoutheast:
                return zero + 22.5
            case .southeast:
                return zero + 45
            case .southSoutheast:
                return zero + 67.5
            case .south:
                return zero + 90
            case .southSouthwest:
                return zero + 112.5
            case .southwest:
                return zero + 135
            case .westSouthwest:
                return zero + 157.5
            case .west:
                return zero - 180
            case .westNorthwest:
                return zero - 157.5
            case .northwest:
                return zero - 135
            case .northNorthwest:
                return zero - 112.5
        }
    }
        
    /// Manually checks for SF Symbols that do not have the fill option and returns that image without .fill added.
    /// Otherwise, .fill is added to the end of the symbol name
    //TODO: Add more sf symbols
    func getImage(imageName: String) -> String {
        switch imageName {
            case "wind":
                return imageName
            case "snowflake":
                return imageName
            case "tornado":
                return imageName
            case "snow":
                return imageName
            default:
                return imageName + ".fill"
        }
    }
}
