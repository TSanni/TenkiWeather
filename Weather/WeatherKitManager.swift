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
    
    var timezoneOffset: Int = 0
    
    
    
    //MARK: - Get Weather from WeatherKit
    /// Will get all the weather data with the coordinates that are passed in.
    func getWeather() async {
        
        do {
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=29.760427&lon=-95.369804&exclude=minutely,hourly,current,daily&units=imperial&appid=40febaf4c7f14979ca5ecbec6a17cd1a") else { return }
            // weather = try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181)) // Cupertino?
//             weather = try await WeatherService.shared.weather(for: .init(latitude: 43.062096, longitude: 141.354370)) // Sapporo Japan
            weather = try await WeatherService.shared.weather(for: .init(latitude: 29.760427, longitude: -95.369804)) // Houston
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 40.712776, longitude: -74.005974)) // New York City
//            weather = try await WeatherService.shared.weather(for: .init(latitude: -75.257721, longitude: 97.818153)) // Antarctica
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 48.856613, longitude: 2.352222)) // Paris
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decdodedData = try JSONDecoder().decode(TimeZoneModel.self, from: data)
            timezoneOffset = decdodedData.timezone_offset
            
            guard let currentWeather = weather?.currentWeather else {
                print("\n\n\n\n UNABLE TO GET CURRENT WEATHER DATA \n\n\n\n")
                return
            }
            
            guard let dailyWeather = weather?.dailyForecast else {
                print("\n\n\n\n UNABLE TO GET DAILY WEATHER DATA \n\n\n\n")
                return
            }
            
            
            
            if let unwrappedCurrentWeather = await getTodayWeather(current: currentWeather, dailyWeather: dailyWeather) {
                await MainActor.run(body: {
                    self.currentWeather = unwrappedCurrentWeather
                })
            }
        } catch {
            fatalError("\(error)")
        }
        
        
    }
    
    
    //MARK: - Get Tomorrow's Weather
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>) async {
        let nextDayWeather = weather?.hourlyForecast.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= tomorrowWeather[1].date.advanced(by: 25200)
        })

    }
    
    
    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>) async -> TodayWeatherModel? {
        
        /// Filters the hourly forecasts and returns only the items that start at the current hour and beyond
        guard let hourlyWeatherStartingFromNow = weather?.hourlyForecast.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        }) else { return nil }
        
        var jddj: [HourWeather] = []
        
        for i in 0..<K.Time.twelveHours {
            jddj.append(hourlyWeatherStartingFromNow[i])
            print("\n")
            print(jddj[i].symbolName)
        }
        
//        print(jddj)
        
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
            sunrise: getReadableHourAndMinute(date: dailyWeather[0].sun.sunrise!),
            sunset: getReadableHourAndMinute(date: dailyWeather[0].sun.sunset!),
            dawn: getReadableHourAndMinute(date: dailyWeather[0].sun.civilDawn!),
            solarNoon: getReadableHourAndMinute(date: dailyWeather[0].sun.solarNoon!),
            dusk: getReadableHourAndMinute(date: dailyWeather[0].sun.civilDusk!)
        )
        
        
        /// 12 hour forecast data for the Wind and temperatures
        for i in 0..<K.Time.twelveHours {
            hourlyWind.append(
                WindData(
                    windSpeed: String(format: "%.0f", hourlyWeatherStartingFromNow[i].wind.speed.value),
                    windDirection: hourlyWeatherStartingFromNow[i].wind.compassDirection,
                    time: getReadableHourOnly(date: hourlyWeatherStartingFromNow[i].date)
                )
            )
            
            hourlyTemperatures.append(
                HourlyTemperatures(
                    temperature: String(format: "%.0f", hourlyWeatherStartingFromNow[i].temperature.converted(to: .fahrenheit).value),
                    date: getReadableHourOnly(date: hourlyWeatherStartingFromNow[i].date),
                    symbol: hourlyWeatherStartingFromNow[i].symbolName,
                    chanceOfPrecipitation: hourlyWeatherStartingFromNow[i].precipitationChance.formatted(.percent)
                )
            )
        }
        
        
        
        /// Weather data for the day (includes current details, wind data, and sun data)
        let todaysWeather = TodayWeatherModel(
            date: getReadableMainDate(date: current.date),
            todayHigh: String(format: "%.0f", dailyWeather[0].highTemperature.converted(to: .fahrenheit).value),
            todayLow: String(format: "%.0f", dailyWeather[0].lowTemperature.converted(to: .fahrenheit).value),
            currentTemperature: String(format: "%.0f", current.temperature.converted(to: .fahrenheit).value),
            feelsLikeTemperature: String(format: "%.0f", current.apparentTemperature.converted(to: .fahrenheit).value),
            symbol: current.symbolName,
            weatherDescription: current.condition,
            chanceOfPrecipitation: dailyWeather[0].precipitationChance.formatted(.percent),
            currentDetails: currentDetailsCardInfo,
            todayWind: windDetailsInfo,
            todayHourlyWind: hourlyWind,
            sunData: sunData,
            isDaylight: current.isDaylight,
            hourlyTemperatures: hourlyTemperatures,
            temperatureUnit: current.temperature.converted(to: .fahrenheit).unit.symbol
        )
        

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
    private func getReadableHourOnly(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: 12:07 PM
    private func getReadableHourAndMinute(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHourAndMinute = dateFormatter.string(from: date)
        return readableHourAndMinute
    }
    
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: July 7, 10:08 PM
    private func getReadableMainDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    

    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    private func getDayOfWeekAndDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
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
    

  
    
    /// Takes the name of an SF Symbol icon and returns an array of colors.
    /// Main purpose is to be used with the foregroundStyle modifier
//    func getSFColorForIcon(sfIcon: String) -> [Color] {
//
//        switch sfIcon {
//        case K.WeatherCondition.sunMax:
//            return [.yellow, .yellow, .yellow]
//        case K.WeatherCondition.moonStars:
//            return [K.Colors.moonColor, K.Colors.offWhite, .clear]
//        case K.WeatherCondition.cloudSun:
//            return [K.Colors.offWhite, .yellow, .clear]
//        case K.WeatherCondition.cloudMoon:
//            return [K.Colors.offWhite, K.Colors.moonColor, .clear]
//        case K.WeatherCondition.cloud:
//            return [K.Colors.offWhite, K.Colors.offWhite, K.Colors.offWhite]
//        case K.WeatherCondition.cloudRain:
//            return [K.Colors.offWhite, .cyan, .clear]
//        case K.WeatherCondition.cloudSunRain:
//            return [K.Colors.offWhite, .yellow, .cyan]
//        case K.WeatherCondition.cloudMoonRain:
//            return [K.Colors.offWhite, K.Colors.moonColor, .cyan]
//        case K.WeatherCondition.cloudBolt:
//            return [K.Colors.offWhite, .yellow, .clear]
//        case K.WeatherCondition.snowflake:
//            return [K.Colors.offWhite, .clear, .clear]
//        case K.WeatherCondition.cloudFog:
//            return [K.Colors.offWhite, .gray, .clear]
//            case K.WeatherCondition.cloudBoltRain:
//                return [K.Colors.offWhite, .cyan, .white]
//            
//        default:
//            print("Error getting color")
//                return [.white, .white, .white]
//        }
//    }
}
