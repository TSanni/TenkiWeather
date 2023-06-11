//
//  WeatherKitManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/7/23.
//

import Foundation
import WeatherKit
import SwiftUI

class WeatherKitManager: ObservableObject {
    private var weather: Weather?
    
    @Published var currentWeather: TodayWeatherModel = TodayWeatherModel.holderData
    @Published var tomorrowWeather: TomorrowWeatherModel = TomorrowWeatherModel.tomorrowDataHolder
    @Published var dailyWeather: [DailyWeatherModel] = [DailyWeatherModel.dailyDataHolder]
    
    //MARK: - Get Weather from WeatherKit
    
    /// Will get all the weather data with the coordinates that are passed in.
    func getWeather() async {
        do {
            // weather = try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181)) // Cupertino?
//             weather = try await WeatherService.shared.weather(for: .init(latitude: 43.062096, longitude: 141.354370)) // Sapporo Japan
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 29.760427, longitude: -95.369804)) // Houston
            weather = try await WeatherService.shared.weather(for: .init(latitude: 48.856613, longitude: 2.352222)) // Paris

            
            if let unwrappedCurrentWeather = await getTodayWeather() {
                await MainActor.run(body: {
                    self.currentWeather = unwrappedCurrentWeather
                })
            }
        } catch {
            fatalError("\(error)")
        }
        
        
    }
    
    
    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather() async -> TodayWeatherModel? {
        guard let current = weather?.currentWeather else { return nil }
        guard let dailyWeather = weather?.dailyForecast else { return nil }
        
        guard let hourlyWeatherStartingFromNow = weather?.hourlyForecast.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        }) else { return nil }
        
        var hourlyWind: [WindData] = []
        var hourlyTemperatures: [HourlyTemperatures] = []
        
        
        /// Weather data for Current details card
        let currentDetailsCardInfo = DetailsModel(
            humidity: current.humidity.formatted(.percent),
            dewPoint: String(format: "%.0f", current.dewPoint.converted(to: .fahrenheit).value) + current.dewPoint.converted(to: .fahrenheit).unit.symbol,
            pressure: getReadableMeasurementPressure(measurement: current.pressure.converted(to: .inchesOfMercury)),
            uvIndex: (current.uvIndex.category.description) + ", " + (current.uvIndex.value.description),
            visibility: getReadableMeasurementLengths(measurement: current.visibility.converted(to: .miles)),
            sunData: nil
        )
        
        /// Weather data for wind
        let windDetailsInfo = WindData(
            windSpeed: String(format: "%.0f", current.wind.speed.value),
            windDirection: current.wind.compassDirection,
            time: nil
        )
        
        /// Weather data for sun events
        let sunData = SunData(
            sunrise: dailyWeather[0].sun.sunrise?.formatted(date: .omitted, time: .shortened) ?? "-",
            sunset: dailyWeather[0].sun.sunset?.formatted(date: .omitted, time: .shortened) ?? "-",
            dawn: dailyWeather[0].sun.nauticalDawn?.formatted(date: .omitted, time: .shortened) ?? "-",
            solarNoon: dailyWeather[0].sun.solarNoon?.formatted(date: .omitted, time: .shortened) ?? "-",
            dusk: dailyWeather[0].sun.nauticalDusk?.formatted(date: .omitted, time: .shortened) ?? "-"
        )
        
        
        for i in 0..<K.twelveHours {
            hourlyWind.append(
                WindData(
                    windSpeed: String(format: "%.0f", hourlyWeatherStartingFromNow[i].wind.speed.value),
                    windDirection: hourlyWeatherStartingFromNow[i].wind.compassDirection,
                    time: getReadableHour(date: hourlyWeatherStartingFromNow[i].date)
                )
            )
            
            hourlyTemperatures.append(
                HourlyTemperatures(
                    temperature: String(format: "%.0f", hourlyWeatherStartingFromNow[i].temperature.converted(to: .fahrenheit).value),
                    date: getReadableHour(date: hourlyWeatherStartingFromNow[i].date),
                    icon: hourlyWeatherStartingFromNow[i].symbolName
                )
            )
        }
        
        
        
        /// Weather data for the day (includes current details, wind data, and sun data)
        let todaysWeather = TodayWeatherModel(
            date: current.date.formatted(date: .abbreviated, time: .shortened),
            todayHigh: String(format: "%.0f", dailyWeather[0].highTemperature.converted(to: .fahrenheit).value),
            todayLow: String(format: "%.0f", dailyWeather[0].lowTemperature.converted(to: .fahrenheit).value),
            currentTemperature: String(format: "%.0f", current.temperature.converted(to: .fahrenheit).value),
            feelsLikeTemperature: String(format: "%.0f", current.apparentTemperature.converted(to: .fahrenheit).value),
            symbol: current.symbolName,
            weatherDescription: current.condition.description ,
            chanceOfPrecipitation: dailyWeather[0].precipitationChance.formatted(.percent),
            currentDetails: currentDetailsCardInfo,
            todayWind: windDetailsInfo,
            todayHourlyWind: hourlyWind,
            sunData: sunData,
            isDaylight: current.isDaylight,
            hourlyTemperatures: hourlyTemperatures
        )
        

//        print("Hourly Wind Data: \(hourlyWind)")
        print(todaysWeather)
        return todaysWeather
        
                
    }
    
    
    
    //MARK: - Private functions
    
    /// Takes a UnitLength measurement and converts it to a readable format by removing floating point numbers.
    /// Returns a String of that format
    private func getReadableMeasurementLengths(measurement: Measurement<UnitLength>) -> String {
        return String(format: "%.0f", measurement.value) + " " + measurement.unit.symbol
        
    }
    
    
    /// Takes a UnitPressure measurement and converts it to a readable format by removing floating numbers.
    /// Returns a String of that format
    private func getReadableMeasurementPressure(measurement: Measurement<UnitPressure>) -> String {
        return String(format: "%.0f", measurement.value) + " " + measurement.unit.symbol
        
    }
     
    
    /// This function takes a date and returns a string with readable date data.
    /// Ex: 7 AM
    private func getReadableHour(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    

    

    
    
    //MARK: - Public functions
    
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
    

    
    
    
    func getSFColorForIcon(sfIcon: String) -> [Color] {

        switch sfIcon {
        case K.WeatherCondition.sunMax:
            return [.yellow, .yellow, .yellow]
        case K.WeatherCondition.moonStars:
            return [K.Colors.moonColor, K.Colors.offWhite, .clear]
        case K.WeatherCondition.cloudSun:
            return [K.Colors.offWhite, .yellow, .clear]
        case K.WeatherCondition.cloudMoon:
            return [K.Colors.offWhite, K.Colors.moonColor, .clear]
        case K.WeatherCondition.cloud:
            return [K.Colors.offWhite, K.Colors.offWhite, K.Colors.offWhite]
        case K.WeatherCondition.cloudRain:
            return [K.Colors.offWhite, .cyan, .clear]
        case K.WeatherCondition.cloudSunRain:
            return [K.Colors.offWhite, .yellow, .cyan]
        case K.WeatherCondition.cloudMoonRain:
            return [K.Colors.offWhite, K.Colors.moonColor, .cyan]
        case K.WeatherCondition.cloudBolt:
            return [K.Colors.offWhite, .yellow, .clear]
        case K.WeatherCondition.snowflake:
            return [K.Colors.offWhite, .clear, .clear]
        case K.WeatherCondition.cloudFog:
            return [K.Colors.offWhite, .gray, .clear]
            case K.WeatherCondition.cloudBoltRain:
                return [K.Colors.offWhite, .cyan, .white]
            
        default:
            print("Error getting color")
                return [.white, .white, .white]
        }
    }
}
