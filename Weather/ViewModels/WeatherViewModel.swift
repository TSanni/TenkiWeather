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
    
    let locationManager = CoreLocationViewModel.shared
    let appStateModel = AppStateManager.shared
    
    private init() { }
    
    func getWeatherWithGoogleData(place: GMSPlace) async {
        let coordinates = place.coordinate
        await locationManager.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, nameFromGoogle: place.name)
        let timezone = locationManager.timezoneForCoordinateInput
        
        await getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
        
        
        appStateModel.setSearchedLocationDictionary(
            name: locationManager.searchedLocationName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: timezone,
            temperature: currentWeather.currentTemperature,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            unitTemperature: getUnitTemperature()
        )
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    private func getUnitTemperature() -> UnitTemperature {
        let savedUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch savedUnitTemperature {
        case K.TemperatureUnits.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnits.celsius:
            return .celsius
        case   K.TemperatureUnits.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
    
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
                await MainActor.run {
                    self.localWeather = WeatherManager.shared.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
                }
            }
        } catch {
            await MainActor.run {
                errorPublisher = (true, error.localizedDescription)
            }
        }
    }
    
    

}
