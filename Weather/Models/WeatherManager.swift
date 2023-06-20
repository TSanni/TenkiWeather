//
//  WeatherManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit

class WeatherManager {
    static let shared = WeatherManager()
    
    
    
    private var timezoneOffset: Int = 0
    private let apiKey = K.apiKey
//    private let url = "https://api.openweathermap.org/data/2.5/onecall?lat=29.760427&lon=-95.369804&exclude=minutely,hourly,current,daily&units=imperial&appid=" // Houston
    private let url = "https://api.openweathermap.org/data/2.5/onecall?lat=43.062096&lon=141.354370&exclude=minutely,hourly,current,daily&units=imperial&appid=" //Sapporo
 
    
    
    func getWeather(latitude: Double, longitude: Double) async throws -> Weather? {
        
        guard let apiKey = apiKey else {
            print("UNABLE TO FIND APIKEY")
            return nil
        }
        
        
        do {
            //TODO: Add a lat and lon string interpolation for dynamic data
            guard let url = URL(string: "\(url)\(apiKey)") else { return nil } // Using Sapporo
            let weather = try await WeatherService.shared.weather(for: .init(latitude: 43.062096, longitude: 141.354370)) // Sapporo Japan
            // weather = try await WeatherService.shared.weather(for: .init(latitude: 37.322998, longitude: -122.032181)) // Cupertino?
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 29.760427, longitude: -95.369804)) // Houston
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 40.712776, longitude: -74.005974)) // New York City
//            weather = try await WeatherService.shared.weather(for: .init(latitude: -75.257721, longitude: 97.818153)) // Antarctica
//            weather = try await WeatherService.shared.weather(for: .init(latitude: 48.856613, longitude: 2.352222)) // Paris
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decdodedData = try JSONDecoder().decode(TimeZoneModel.self, from: data)
            timezoneOffset = decdodedData.timezone_offset
            return weather
 
        } catch {
            fatalError("\(error)")
        }
        
        
    }
    
    
    
    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>) -> TodayWeatherModel {
        
        /// Filters the hourly forecasts and returns only the items that start at the current hour and beyond
         let hourlyWeatherStartingFromNow = hourlyWeather.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        })
        
        
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
    
    
    
    //MARK: - Get Tomorrow's Weather
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>) -> TomorrowWeatherModel {
        let tomorrowWeather = tomorrowWeather[1]
        
        /// Gets all hourly forecasts starting with 7AM tomorrow
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= tomorrowWeather.date.advanced(by: 25200)
        })
        
        /// Will hold tomorrow's hourly forecasts for the next 12 hours starting with 7AM
        var tomorrow12HourForecast: [HourWeather] = []
        
        /// Will hold tomorrow's hourly wind data for the next 12 hours starting with 7AM
        var tomorrowHourlyWind: [WindData] = []
        
        /// Will hold tomorrow's hourly temperatures
        var tomorrowHourlyTemperatures: [HourlyTemperatures] = []

        
        for hour in 0..<K.Time.twelveHours {
            tomorrow12HourForecast.append(nextDayWeatherHours[hour])
            
        }
        
        for hour in 0..<K.Time.twelveHours {
            tomorrowHourlyWind.append(WindData(
                windSpeed: String(format: "%.0f", tomorrow12HourForecast[hour].wind.speed.value),
                windDirection: tomorrow12HourForecast[hour].wind.compassDirection,
                time: getReadableHourOnly(date: tomorrow12HourForecast[hour].date)))
            
            
            tomorrowHourlyTemperatures.append(HourlyTemperatures(
                temperature: String(format: "%.0f", tomorrow12HourForecast[hour].temperature.converted(to: .fahrenheit).value),
                date: getReadableHourOnly(date: tomorrow12HourForecast[hour].date),
                symbol: tomorrow12HourForecast[hour].symbolName,
                chanceOfPrecipitation: tomorrow12HourForecast[hour].precipitationChance.formatted(.percent))
            )
            
        }
        

        
        let sunDetails = SunData(
            sunrise: getReadableHourAndMinute(date: tomorrowWeather.sun.sunrise!),
            sunset: getReadableHourAndMinute(date: tomorrowWeather.sun.sunset!),
            dawn: "",
            solarNoon: "",
            dusk: ""
        )
        
        let tomorrowDetails = DetailsModel(
            humidity: nil,
            dewPoint: nil,
            pressure: nil,
            uvIndex: tomorrowWeather.uvIndex.category.description + ", " + tomorrowWeather.uvIndex.value.description,
            visibility: nil,
            sunData: sunDetails
        )
        
        let tomorrowWind = WindData(
            windSpeed: String(format: "%.0f", tomorrowWeather.wind.speed.value),
            windDirection: tomorrowWeather.wind.compassDirection,
            time: nil
        )
        
        
        let tomorrowsWeather = TomorrowWeatherModel(
            date: getDayOfWeekAndDate(date: tomorrowWeather.date),
            tomorrowLow: String(format: "%.0f", tomorrowWeather.lowTemperature.converted(to: .fahrenheit).value),
            tomorrowHigh: String(format: "%.0f", tomorrowWeather.highTemperature.converted(to: .fahrenheit).value),
            tomorrowSymbol: tomorrowWeather.symbolName,
            tomorrowWeatherDescription: tomorrowWeather.condition,
            tomorrowChanceOfPrecipitation: tomorrowWeather.precipitationChance.formatted(.percent),
            tomorrowDetails: tomorrowDetails,
            tomorrowWind: tomorrowWind,
            tomorrowHourlyWind: tomorrowHourlyWind,
            hourlyTemperatures: tomorrowHourlyTemperatures
        )
        
        return tomorrowsWeather

    }

    
    //MARK: - Get the Daily Weather
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>) -> [DailyWeatherModel] {

        var daily: [DailyWeatherModel] = []



        for day in 0..<dailyWeather.count {
            
            let windDetails = WindData(
                windSpeed: String(format: "%.0f", dailyWeather[day].wind.speed.value),
                windDirection: dailyWeather[day].wind.compassDirection,
                time: nil
            )
            
            let sunData = SunData(
                sunrise: getReadableHourAndMinute(date: dailyWeather[day].sun.sunrise!),
                sunset: getReadableHourAndMinute(date: dailyWeather[day].sun.sunset!),
                dawn: "",
                solarNoon: "",
                dusk: ""
            )
            
            let hourlyTempsForDay = getHourlyWeatherForDay(day: dailyWeather[day], hours: hourlyWeather)
            

            daily.append(
                DailyWeatherModel(
                    date: getDayOfWeekAndDate(date: dailyWeather[day].date),
                    dailyWeatherDescription: dailyWeather[day].condition,
                    dailyChanceOfPrecipitation: dailyWeather[day].precipitationChance.formatted(.percent),
                    dailySymbol: dailyWeather[day].symbolName,
                    dailyLowTemp: String(format: "%.0f", dailyWeather[day].lowTemperature.converted(to: .fahrenheit).value),
                    dailyHighTemp: String(format: "%.0f", dailyWeather[day].highTemperature.converted(to: .fahrenheit).value),
                    dailyWind: windDetails,
                    dailyUVIndex: dailyWeather[day].uvIndex.category.description + ", " + dailyWeather[day].uvIndex.value.description,
                    sunEvents: sunData,
                    hourlyTemperatures: hourlyTempsForDay
                )
            )
        }

        return daily
    }

    
}


//MARK: - Private functions
extension WeatherManager {
    
    /// This functions returns an array of hourly weather data for the next fifteen hours.
    private func getHourlyWeatherForDay(day: DayWeather, hours: Forecast<HourWeather>) -> [HourlyTemperatures] {
        var fifteenHours: [HourlyTemperatures] = []
        
        
        /// Gets all hourly forecasts starting with 7AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= day.date.advanced(by: 25200)
        })
        

        
        for i in 0..<15 {
            fifteenHours.append(
                HourlyTemperatures(
                    temperature: String(format: "%.0f", nextDayWeatherHours[i].temperature.converted(to: .fahrenheit).value),
                    date: getReadableHourOnly(date: nextDayWeatherHours[i].date),
                    symbol: nextDayWeatherHours[i].symbolName,
                    chanceOfPrecipitation: nextDayWeatherHours[i].precipitationChance.formatted(.percent)
                )
            )
        }
        
        return fifteenHours
        
        
    }

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
}



//MARK: - Public functions
extension WeatherManager {

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
}