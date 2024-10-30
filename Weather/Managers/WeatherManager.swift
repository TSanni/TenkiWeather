//
//  WeatherManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit



actor WeatherManager {
    static let shared = WeatherManager()
  
    func getWeatherFromWeatherKit(latitude: Double, longitude: Double, timezone: Int) async throws -> Weather? {
        do {
            let weather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            return weather
            
        } catch {
            throw WeatherErrors.failedToGetWeatherKitData
        }
    }

    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> TodayWeatherModel {
        
        /// Filters the hourly forecasts and returns only the items that start at the current hour and beyond
         let hourlyDatesStartingFromNow = hourlyWeather.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        })
        
        var hourlyTemperatures: [HourlyWeatherModel] = []
                
        /// Weather data for wind
        let windDetailsInfo = WindModel(
            speed: current.wind.speed,
            compassDirection: current.wind.compassDirection
        )
        
        /// Weather data for sun events
        let sunData = SunModel(
            sunrise: dailyWeather[0].sun.sunrise,
            sunset: dailyWeather[0].sun.sunset,
            civilDawn: dailyWeather[0].sun.civilDawn,
            solarNoon: dailyWeather[0].sun.solarNoon,
            civilDusk: dailyWeather[0].sun.civilDusk,
            timezone: timezoneOffset
        )
        
        /// 12 hour forecast data for the Wind and temperatures
        for i in 0..<K.TimeConstants.twentyFourHours {
            
            let windData =  WindModel(
                speed: hourlyDatesStartingFromNow[i].wind.speed,
                compassDirection: hourlyDatesStartingFromNow[i].wind.compassDirection
            )
            
            hourlyTemperatures.append(
                HourlyWeatherModel(
                    temperature: hourlyDatesStartingFromNow[i].temperature, 
                    wind: windData,
                    date: hourlyDatesStartingFromNow[i].date,
                    precipitationChance: hourlyDatesStartingFromNow[i].precipitationChance, 
                    symbol: hourlyDatesStartingFromNow[i].symbolName,
                    timezone: timezoneOffset,
                    condition: hourlyDatesStartingFromNow[i].condition,
                    isDayLight: hourlyDatesStartingFromNow[i].isDaylight
                )
            )
        }
        
        /// Weather data for the day (includes current details, wind data, and sun data)
        let todaysWeather = TodayWeatherModel(
            apparentTemperature: current.apparentTemperature, 
            dewPoint: current.dewPoint, 
            humidity: current.humidity,
            temperature: current.temperature,
            pressure: current.pressure,
            pressureTrend: current.pressureTrend,
            wind: windDetailsInfo, 
            condition: current.condition,
            date: current.date,
            isDaylight: current.isDaylight, 
            uvIndexCategory: current.uvIndex.category,
            uvIndexValue: current.uvIndex.value, 
            visibility: current.visibility,
            symbolName: current.symbolName,
            highTemperature: dailyWeather[0].highTemperature,
            lowTemperature: dailyWeather[0].lowTemperature,
            precipitationChance: dailyWeather[0].precipitationChance,
            sunData: sunData,
            hourlyWeather: hourlyTemperatures,
            timezeone: timezoneOffset
        )

        return todaysWeather
    }
    
    //MARK: - Get Tomorrow's Weather
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneOffset: Int) -> DailyWeatherModel {
        /// Tomorrow's date
        let tomorrowWeather = tomorrowWeather[1]
        
        let hourlyWeatherForTomorrow = getHourlyWeatherForDay(day: tomorrowWeather, hours: hours, timezoneOffset: timezoneOffset)

        let sunDetails = SunModel(
            sunrise: tomorrowWeather.sun.sunrise,
            sunset: tomorrowWeather.sun.sunset,
            civilDawn: tomorrowWeather.sun.civilDawn,
            solarNoon: tomorrowWeather.sun.solarNoon,
            civilDusk: tomorrowWeather.sun.civilDusk,
            timezone: timezoneOffset
        )
        
        let tomorrowsWindData = WindModel(
            speed: tomorrowWeather.wind.speed,
            compassDirection: tomorrowWeather.wind.compassDirection
        )
        
        let tomorrowsWeather = DailyWeatherModel(
            highTemperature: tomorrowWeather.highTemperature,
            lowTemperature: tomorrowWeather.lowTemperature,
            precipitation: tomorrowWeather.precipitation,
            precipitationChance: tomorrowWeather.precipitationChance,
            moon: nil,
            sun: sunDetails,
            wind: tomorrowsWindData,
            date: tomorrowWeather.date,
            condition: tomorrowWeather.condition,
            uvIndexValue: tomorrowWeather.uvIndex.value,
            uvIndexCategory: tomorrowWeather.uvIndex.category,
            symbolName: tomorrowWeather.symbolName,
            hourlyWeather: hourlyWeatherForTomorrow,
            timezone: timezoneOffset,
            precipitationAmountByType: tomorrowWeather.precipitationAmountByType
        )
        
        return tomorrowsWeather
    }
    
    //MARK: - Get the Daily Weather
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> [DailyWeatherModel] {

        var daily: [DailyWeatherModel] = []

        for day in 0..<dailyWeather.count {
            
            let sunData = SunModel(
                sunrise: dailyWeather[day].sun.sunrise,
                sunset: dailyWeather[day].sun.sunset,
                civilDawn: dailyWeather[day].sun.civilDawn,
                solarNoon: dailyWeather[day].sun.solarNoon,
                civilDusk: dailyWeather[day].sun.civilDusk,
                timezone: timezoneOffset
            )
            
            let windDetails = WindModel(
                speed: dailyWeather[day].wind.speed,
                compassDirection: dailyWeather[day].wind.compassDirection
            )
            
            let hourlyTempsForDay = getHourlyWeatherForDay(day: dailyWeather[day], hours: hourlyWeather, timezoneOffset: timezoneOffset)
            
            daily.append(
                DailyWeatherModel(
                    highTemperature: dailyWeather[day].highTemperature,
                    lowTemperature: dailyWeather[day].lowTemperature,
                    precipitation: dailyWeather[day].precipitation,
                    precipitationChance: dailyWeather[day].precipitationChance,
                    moon: dailyWeather[day].moon,
                    sun: sunData,
                    wind: windDetails,
                    date: dailyWeather[day].date,
                    condition: dailyWeather[day].condition,
                    uvIndexValue: dailyWeather[day].uvIndex.value,
                    uvIndexCategory: dailyWeather[day].uvIndex.category,
                    symbolName: dailyWeather[day].symbolName,
                    hourlyWeather: hourlyTempsForDay,
                    timezone: timezoneOffset,
                    precipitationAmountByType: dailyWeather[day].precipitationAmountByType
                )
            )
        }

        return daily
    }
    
    //MARK: - Get Optional Weather Alert
    func getWeatherAlert(optionalWeatherAlert: [WeatherAlert]?) -> WeatherAlertModel? {
        
        /// if the optionalWeatherAlert passed in is NOT nil
        if let unwrappedWeatherAlerts = optionalWeatherAlert {
            
            /// if there is data in optionalWeatherAlert
            if !unwrappedWeatherAlerts.isEmpty {
                
                let weatherAlert = WeatherAlertModel(
                    detailsURL: unwrappedWeatherAlerts[0].detailsURL,
                    region: unwrappedWeatherAlerts[0].region,
                    severity: unwrappedWeatherAlerts[0].severity,
                    source: unwrappedWeatherAlerts[0].source,
                    summary: unwrappedWeatherAlerts[0].summary
                )
                
                return weatherAlert
                

            } else { /// if optionalWeatherAlert is an empty ARRAY
                return nil
            }
            
        } else { /// if the optionalWeatherAlert passed in is NIL
            return nil
        }
    }
}


//MARK: - Private functions
extension WeatherManager {
    
    /// This functions returns an array of hourly weather data for the next fifteen hours.
    private func getHourlyWeatherForDay(day: DayWeather, hours: Forecast<HourWeather>, timezoneOffset: Int) -> [HourlyWeatherModel] {
        var fifteenHours: [HourlyWeatherModel] = []
        
        /// Gets all hourly forecasts starting with 7AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= day.date.advanced(by: K.TimeConstants.sevenHoursInSeconds)
        })
        
        //TODO: Add error handling to catch when the there aren't enough hours
        for i in 0..<K.TimeConstants.fifteenHours {
            
            let windData = WindModel(
                speed: nextDayWeatherHours[i].wind.speed,
                compassDirection: nextDayWeatherHours[i].wind.compassDirection
            )
            
            fifteenHours.append(
                HourlyWeatherModel(
                    temperature: nextDayWeatherHours[i].temperature, 
                    wind: windData,
                    date: nextDayWeatherHours[i].date,
                    precipitationChance: nextDayWeatherHours[i].precipitationChance, 
                    symbol: nextDayWeatherHours[i].symbolName,
                    timezone: timezoneOffset,
                    condition: nextDayWeatherHours[i].condition,
                    isDayLight: nextDayWeatherHours[i].isDaylight
                )
            )
        }
        
        return fifteenHours
    }
}
