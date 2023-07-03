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
    

    func getWeather(latitude: Double, longitude: Double, timezone: Int) async throws -> Weather? {
        
        do {

            let weather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude)) // passedd in coordinates

            return weather
 
        } catch {
            print("ERROR IN GETWEATHER FUNCTION \(error)")
            return nil
//            fatalError("ERROR IN GETWEATHER FUNCTION: \(error)")
        }
    }
    
    
    
    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> TodayWeatherModel {
        
        /// Filters the hourly forecasts and returns only the items that start at the current hour and beyond
         let hourlyWeatherStartingFromNow = hourlyWeather.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        })
        
        
        var hourlyWind: [WindData] = []
        var hourlyTemperatures: [HourlyTemperatures] = []
        
        
        /// Weather data for Current details card
        let currentDetailsCardInfo = DetailsModel(
            humidity: current.humidity.formatted(.percent),
            dewPoint: String(format: "%.0f", current.dewPoint.converted(to: getUnitTemperature()).value) + current.dewPoint.converted(to: getUnitTemperature()).unit.symbol,
            pressure: getReadableMeasurementPressure(measurement: current.pressure.converted(to: .inchesOfMercury)),
            uvIndex: (current.uvIndex.category.description) + ", " + (current.uvIndex.value.description),
            visibility: getReadableMeasurementLengths(measurement: current.visibility.converted(to: getUnitLength())),
            sunData: nil
        )
        
        /// Weather data for wind
        let windDetailsInfo = WindData(
            windSpeed: String(format: "%.0f", current.wind.speed.converted(to: getUnitSpeed()).value),
            windDirection: current.wind.compassDirection,
            time: nil,
            speedUnit: current.wind.speed.converted(to: getUnitSpeed()).unit.symbol
        )
        
        /// Weather data for sun events
        let sunData = SunData(
            sunrise: getReadableHourAndMinute(date: dailyWeather[0].sun.sunrise, timezoneOffset: timezoneOffset),
            sunset: getReadableHourAndMinute(date: dailyWeather[0].sun.sunset, timezoneOffset: timezoneOffset),
            dawn: getReadableHourAndMinute(date: dailyWeather[0].sun.civilDawn, timezoneOffset: timezoneOffset),
            solarNoon: getReadableHourAndMinute(date: dailyWeather[0].sun.solarNoon, timezoneOffset: timezoneOffset),
            dusk: getReadableHourAndMinute(date: dailyWeather[0].sun.civilDusk, timezoneOffset: timezoneOffset)
        )
        
        
        /// 12 hour forecast data for the Wind and temperatures
        for i in 0..<K.Time.fifteenHours {
            hourlyWind.append(
                WindData(
                    windSpeed: String(format: "%.0f", hourlyWeatherStartingFromNow[i].wind.speed.converted(to: getUnitSpeed()).value),
                    windDirection: hourlyWeatherStartingFromNow[i].wind.compassDirection,
                    time: getReadableHourOnly(date: hourlyWeatherStartingFromNow[i].date, timezoneOffset: timezoneOffset),
                    speedUnit: hourlyWeatherStartingFromNow[i].wind.speed.converted(to: getUnitSpeed()).unit.symbol
                )
            )
            
            hourlyTemperatures.append(
                HourlyTemperatures(
                    temperature: String(format: "%.0f", hourlyWeatherStartingFromNow[i].temperature.converted(to: getUnitTemperature()).value),
                    date: getReadableHourOnly(date: hourlyWeatherStartingFromNow[i].date, timezoneOffset: timezoneOffset),
                    symbol: hourlyWeatherStartingFromNow[i].symbolName,
                    chanceOfPrecipitation: hourlyWeatherStartingFromNow[i].precipitationChance.formatted(.percent)
                )
            )
        }
        
        
        
        /// Weather data for the day (includes current details, wind data, and sun data)
        let todaysWeather = TodayWeatherModel(
            date: getReadableMainDate(date: current.date, timezoneOffset: timezoneOffset),
            todayHigh: String(format: "%.0f", dailyWeather[0].highTemperature.converted(to: getUnitTemperature()).value),
            todayLow: String(format: "%.0f", dailyWeather[0].lowTemperature.converted(to: getUnitTemperature()).value),
            currentTemperature: String(format: "%.0f", current.temperature.converted(to: getUnitTemperature()).value),
            feelsLikeTemperature: String(format: "%.0f", current.apparentTemperature.converted(to: getUnitTemperature()).value),
            symbol: current.symbolName,
            weatherDescription: current.condition,
            chanceOfPrecipitation: dailyWeather[0].precipitationChance.formatted(.percent),
            currentDetails: currentDetailsCardInfo,
            todayWind: windDetailsInfo,
            todayHourlyWind: hourlyWind,
            sunData: sunData,
            isDaylight: current.isDaylight,
            hourlyTemperatures: hourlyTemperatures,
            temperatureUnit: current.temperature.converted(to: getUnitTemperature()).unit.symbol
            
        )
        

        return todaysWeather
        
                
    }
    
    
    
    //MARK: - Get Tomorrow's Weather
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneOffset: Int) -> TomorrowWeatherModel {
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

        
        for hour in 0..<K.Time.fifteenHours {
            tomorrow12HourForecast.append(nextDayWeatherHours[hour])
            
        }
        
        for hour in 0..<K.Time.fifteenHours {
            tomorrowHourlyWind.append(WindData(
                windSpeed: String(format: "%.0f", tomorrow12HourForecast[hour].wind.speed.converted(to: getUnitSpeed()).value),
                windDirection: tomorrow12HourForecast[hour].wind.compassDirection,
                time: getReadableHourOnly(date: tomorrow12HourForecast[hour].date, timezoneOffset: timezoneOffset),
                speedUnit: tomorrow12HourForecast[hour].wind.speed.converted(to: getUnitSpeed()).unit.symbol))
            
            
            tomorrowHourlyTemperatures.append(HourlyTemperatures(
                temperature: String(format: "%.0f", tomorrow12HourForecast[hour].temperature.converted(to: getUnitTemperature()).value),
                date: getReadableHourOnly(date: tomorrow12HourForecast[hour].date, timezoneOffset: timezoneOffset),
                symbol: tomorrow12HourForecast[hour].symbolName,
                chanceOfPrecipitation: tomorrow12HourForecast[hour].precipitationChance.formatted(.percent))
            )
            
        }
        

        
        let sunDetails = SunData(
            sunrise: getReadableHourAndMinute(date: tomorrowWeather.sun.sunrise, timezoneOffset: timezoneOffset),
            sunset: getReadableHourAndMinute(date: tomorrowWeather.sun.sunset, timezoneOffset: timezoneOffset),
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
            windSpeed: String(format: "%.0f", tomorrowWeather.wind.speed.converted(to: getUnitSpeed()).value),
            windDirection: tomorrowWeather.wind.compassDirection,
            time: nil,
            speedUnit: tomorrowWeather.wind.speed.converted(to: getUnitSpeed()).unit.symbol
        )
        
        
        let tomorrowsWeather = TomorrowWeatherModel(
            date: getDayOfWeekAndDate(date: tomorrowWeather.date, timezoneOffset: timezoneOffset),
            tomorrowLow: String(format: "%.0f", tomorrowWeather.lowTemperature.converted(to: getUnitTemperature()).value),
            tomorrowHigh: String(format: "%.0f", tomorrowWeather.highTemperature.converted(to: getUnitTemperature()).value),
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
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> [DailyWeatherModel] {

        var daily: [DailyWeatherModel] = []



        for day in 0..<dailyWeather.count {
            
            let windDetails = WindData(
                windSpeed: String(format: "%.0f", dailyWeather[day].wind.speed.converted(to: getUnitSpeed()).value),
                windDirection: dailyWeather[day].wind.compassDirection,
                time: nil,
                speedUnit: dailyWeather[day].wind.speed.converted(to: getUnitSpeed()).unit.symbol
            )
            
            let sunData = SunData(
                sunrise: getReadableHourAndMinute(date: dailyWeather[day].sun.sunrise, timezoneOffset: timezoneOffset),
                sunset: getReadableHourAndMinute(date: dailyWeather[day].sun.sunset, timezoneOffset: timezoneOffset),
                dawn: "",
                solarNoon: "",
                dusk: ""
            )
            
            let hourlyTempsForDay = getHourlyWeatherForDay(day: dailyWeather[day], hours: hourlyWeather, timezoneOffset: timezoneOffset)
            

            daily.append(
                DailyWeatherModel(
                    date: getDayOfWeekAndDate(date: dailyWeather[day].date, timezoneOffset: timezoneOffset),
                    dailyWeatherDescription: dailyWeather[day].condition,
                    dailyChanceOfPrecipitation: dailyWeather[day].precipitationChance.formatted(.percent),
                    dailySymbol: dailyWeather[day].symbolName,
                    dailyLowTemp: String(format: "%.0f", dailyWeather[day].lowTemperature.converted(to: getUnitTemperature()).value),
                    dailyHighTemp: String(format: "%.0f", dailyWeather[day].highTemperature.converted(to: getUnitTemperature()).value),
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
    private func getHourlyWeatherForDay(day: DayWeather, hours: Forecast<HourWeather>, timezoneOffset: Int) -> [HourlyTemperatures] {
        var fifteenHours: [HourlyTemperatures] = []
        
        
        /// Gets all hourly forecasts starting with 7AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= day.date.advanced(by: 25200)
        })
        

        
        for i in 0..<15 {
            fifteenHours.append(
                HourlyTemperatures(
                    temperature: String(format: "%.0f", nextDayWeatherHours[i].temperature.converted(to: getUnitTemperature()).value),
                    date: getReadableHourOnly(date: nextDayWeatherHours[i].date, timezoneOffset: timezoneOffset),
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
    private func getReadableHourOnly(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableHour = dateFormatter.string(from: date)
        return readableHour
    }
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: 12:07 PM
    private func getReadableHourAndMinute(date: Date?, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        if let date = date {
            let readableHourAndMinute = dateFormatter.string(from: date)
            return readableHourAndMinute
        } else {
            return "-"
        }
    }
    
    
    /// This function accepts a date and returns a string of that date in a readable format
    ///  Ex: July 7, 10:08 PM
    private func getReadableMainDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, h:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    

    /// This functions accepts a date and returns a string of that date in a readable format
    /// Ex: Tuesday, July 7
    private func getDayOfWeekAndDate(date: Date, timezoneOffset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    
    private func getUnitLength() -> UnitLength {
        let unitSpeed = getUnitSpeed()
        
        switch unitSpeed {
            case .milesPerHour:
                return .miles
            case .kilometersPerHour:
                return .kilometers
            case .metersPerSecond:
                return .meters
            default:
                print("Unable to get unit length")
                return .miles
        }
    }
    
    
    private func getUnitTemperature() -> UnitTemperature {
        let chosenUnitTemperature = UserDefaults.standard.string(forKey: "unittemperature")
        
        switch chosenUnitTemperature {
            case "Fahrenheit":
                return .fahrenheit
            case "Celsius":
                return .celsius
            case "Kelvin":
                return .kelvin
            default:
                print("CANT GET UNIT TEMPERATURE")
                return .fahrenheit
        }
    }
    
    
    private func getUnitSpeed() -> UnitSpeed {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: "unitdistance")
        
        switch chosenUnitDistance {
            case  "Miles per hour":
                return .milesPerHour
            case "Kilometers per hour":
                return .kilometersPerHour
            case "Meters per second":
                return .metersPerSecond
            case "Knots":
                return .knots
            default:
                print("CAN'T GET UNIT SPEED")
                return .milesPerHour
        }
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
                
            default:
                return imageName + ".fill"
        }
    }
}
