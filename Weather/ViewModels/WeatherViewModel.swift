//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit
import GooglePlaces


@MainActor class WeatherViewModel: ObservableObject {
    @Published var currentWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var tomorrowWeather: DailyWeatherModel = DailyWeatherModel.placeholder
    @Published var dailyWeather: [DailyWeatherModel] = [DailyWeatherModel.placeholder]
    @Published var weatherAlert: WeatherAlertModel? = nil
    @Published var localWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var errorPublisher: (errorBool: Bool, errorMessage: String) = (false, "")
    
    static let shared = WeatherViewModel()
    
    let weatherManager = WeatherManager.shared
    let locationManager = CoreLocationViewModel.shared
    let appStateManager = AppStateManager.shared
    
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
                let localWeather = await weatherManager.getTodayWeather(current: weather.currentWeather, dailyWeather: weather.dailyForecast, hourlyWeather: weather.hourlyForecast, timezoneOffset: timezone)
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

    func getWeatherAndUpdateDictionaryFromSavedLocation(item: LocationEntity) async {
        appStateManager.toggleShowSearchScreen()
        appStateManager.dataIsLoading()
        await locationManager.getLocalLocationName()
        await locationManager.getSearchedLocationName(lat: item.latitude, lon: item.longitude, nameFromGoogle: nil)
        await getWeather(latitude: item.latitude, longitude: item.longitude, timezone: locationManager.timezoneForCoordinateInput)
        await getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: locationManager.localLocationName, timezone: appStateManager.currentLocationTimezone)
        
        locationManager.searchedLocationName = item.name!

        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.name] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.longitude] = item.longitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.latitude] = item.latitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.timezone] = item.timezone
        
        appStateManager.dataCompletedLoading()
        appStateManager.performViewReset()
    }
    
    func getWeatherAndUpdateDictionaryFromLocation() async {
        appStateManager.toggleShowSearchScreen()
        appStateManager.dataIsLoading()
        await locationManager.getLocalLocationName()
        let timezone = locationManager.timezoneForCoordinateInput
        await getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
        let userLocationName = locationManager.localLocationName
        await getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
        locationManager.searchedLocationName = userLocationName
        
        appStateManager.setCurrentLocationName(name: userLocationName)
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.name] = locationManager.searchedLocationName
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.latitude] = locationManager.latitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.longitude] = locationManager.longitude
        appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.timezone] = timezone
        
        
        appStateManager.dataCompletedLoading()
        appStateManager.performViewReset()
    }
    
    func getWeatherWithGoogleData(place: GMSPlace) async {
        
        appStateManager.dataIsLoading()
        let coordinates = place.coordinate
        await locationManager.getSearchedLocationName(lat: coordinates.latitude, lon: coordinates.longitude, nameFromGoogle: place.name)
        let timezone = locationManager.timezoneForCoordinateInput
        await getWeather(latitude: coordinates.latitude, longitude:coordinates.longitude, timezone: timezone)
        
        appStateManager.setSearchedLocationDictionary(
            name: locationManager.searchedLocationName,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            timezone: timezone,
            temperature: currentWeather.currentTemperature,
            date: currentWeather.readableDate,
            symbol: currentWeather.symbolName,
            weatherCondition: currentWeather.weatherDescription.description,
            unitTemperature: Helper.getUnitTemperature()
        )
        
        appStateManager.dataCompletedLoading()
        appStateManager.toggleShowSearchScreen()
        appStateManager.performViewReset()
    }

}
