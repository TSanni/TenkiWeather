//
//  WeatherManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit

protocol WeatherServiceProtocol {
    func fetchWeatherFromWeatherKit(latitude: Double, longitude: Double, timezoneIdentifier: String) async throws -> Weather

    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> TodayWeatherModel
    
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneIdentifier: String) -> DailyWeatherModel
    
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> [DailyWeatherModel]

    func getWeatherAlert(optionalWeatherAlert: [WeatherAlert]?) -> WeatherAlertModel?
}

class ProductionWeatherService: WeatherServiceProtocol {
  
    func fetchWeatherFromWeatherKit(latitude: Double, longitude: Double, timezoneIdentifier: String) async throws -> Weather {
        do {
            let weather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            return weather
            
        } catch {
            throw WeatherErrors.failedToGetWeatherKitData
        }
    }

    //MARK: - Get the Current Weather
    // add a parameter here that takes UnitTemperature type
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> TodayWeatherModel {
        
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
            timezoneIdentifier: timezoneIdentifier
        )
        
        let moonData = MoonModel(
            moonrise: dailyWeather[0].moon.moonrise,
            moonset: dailyWeather[0].moon.moonset,
            phase: dailyWeather[0].moon.phase,
            timezoneIdentifier: timezoneIdentifier
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
                    timezoneIdentifier: timezoneIdentifier,
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
            timezoneIdentifier: timezoneIdentifier,
            moonData: moonData
        )

        return todaysWeather
    }
    
    //MARK: - Get Tomorrow's Weather
    func getTomorrowWeather(tomorrowWeather: Forecast<DayWeather>, hours: Forecast<HourWeather>, timezoneIdentifier: String) -> DailyWeatherModel {
        /// Tomorrow's date
        let tomorrowWeather = tomorrowWeather[1]
        
        let hourlyWeatherForTomorrow = getHourlyWeatherForDay(day: tomorrowWeather, hours: hours, timezoneIdentifier: timezoneIdentifier)

        let sunDetails = SunModel(
            sunrise: tomorrowWeather.sun.sunrise,
            sunset: tomorrowWeather.sun.sunset,
            civilDawn: tomorrowWeather.sun.civilDawn,
            solarNoon: tomorrowWeather.sun.solarNoon,
            civilDusk: tomorrowWeather.sun.civilDusk,
            timezoneIdentifier: timezoneIdentifier
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
            sun: sunDetails,
            wind: tomorrowsWindData,
            date: tomorrowWeather.date,
            condition: tomorrowWeather.condition,
            uvIndexValue: tomorrowWeather.uvIndex.value,
            uvIndexCategory: tomorrowWeather.uvIndex.category,
            symbolName: tomorrowWeather.symbolName,
            hourlyWeather: hourlyWeatherForTomorrow,
            timezoneIdentifier: timezoneIdentifier,
            precipitationAmountByType: tomorrowWeather.precipitationAmountByType
        )
        
        return tomorrowsWeather
    }
    
    //MARK: - Get the Daily Weather
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneIdentifier: String) -> [DailyWeatherModel] {

        var daily: [DailyWeatherModel] = []

        for day in 0..<dailyWeather.count {
            
            let sunData = SunModel(
                sunrise: dailyWeather[day].sun.sunrise,
                sunset: dailyWeather[day].sun.sunset,
                civilDawn: dailyWeather[day].sun.civilDawn,
                solarNoon: dailyWeather[day].sun.solarNoon,
                civilDusk: dailyWeather[day].sun.civilDusk,
                timezoneIdentifier: timezoneIdentifier
            )
            
            let windDetails = WindModel(
                speed: dailyWeather[day].wind.speed,
                compassDirection: dailyWeather[day].wind.compassDirection
            )
            
            let hourlyTempsForDay = getHourlyWeatherForDay(day: dailyWeather[day], hours: hourlyWeather, timezoneIdentifier: timezoneIdentifier)
            
            daily.append(
                DailyWeatherModel(
                    highTemperature: dailyWeather[day].highTemperature,
                    lowTemperature: dailyWeather[day].lowTemperature,
                    precipitation: dailyWeather[day].precipitation,
                    precipitationChance: dailyWeather[day].precipitationChance,
                    sun: sunData,
                    wind: windDetails,
                    date: dailyWeather[day].date,
                    condition: dailyWeather[day].condition,
                    uvIndexValue: dailyWeather[day].uvIndex.value,
                    uvIndexCategory: dailyWeather[day].uvIndex.category,
                    symbolName: dailyWeather[day].symbolName,
                    hourlyWeather: hourlyTempsForDay,
                    timezoneIdentifier: timezoneIdentifier,
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
extension ProductionWeatherService {
    
    /// This functions returns an array of hourly weather data for the next fifteen hours.
    private func getHourlyWeatherForDay(day: DayWeather, hours: Forecast<HourWeather>, timezoneIdentifier: String) -> [HourlyWeatherModel] {
        var allHours: [HourlyWeatherModel] = []
        
        /// Gets all hourly forecasts starting with 12AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 0 seconds (0 hours)
            return hourWeather.date >= day.date.advanced(by: 0)
        })
        
        if nextDayWeatherHours.count < K.TimeConstants.twentyFourHours {

            for i in 0..<K.TimeConstants.fifteenHours {
                
                let windData = WindModel(
                    speed: nextDayWeatherHours[i].wind.speed,
                    compassDirection: nextDayWeatherHours[i].wind.compassDirection
                )
                
                allHours.append(
                    HourlyWeatherModel(
                        temperature: nextDayWeatherHours[i].temperature,
                        wind: windData,
                        date: nextDayWeatherHours[i].date,
                        precipitationChance: nextDayWeatherHours[i].precipitationChance,
                        symbol: nextDayWeatherHours[i].symbolName,
                        timezoneIdentifier: timezoneIdentifier,
                        condition: nextDayWeatherHours[i].condition,
                        isDayLight: nextDayWeatherHours[i].isDaylight
                    )
                )
            }
        } else {

            for i in 0..<K.TimeConstants.twentyFourHours {
                
                let windData = WindModel(
                    speed: nextDayWeatherHours[i].wind.speed,
                    compassDirection: nextDayWeatherHours[i].wind.compassDirection
                )
                
                allHours.append(
                    HourlyWeatherModel(
                        temperature: nextDayWeatherHours[i].temperature,
                        wind: windData,
                        date: nextDayWeatherHours[i].date,
                        precipitationChance: nextDayWeatherHours[i].precipitationChance,
                        symbol: nextDayWeatherHours[i].symbolName,
                        timezoneIdentifier: timezoneIdentifier,
                        condition: nextDayWeatherHours[i].condition,
                        isDayLight: nextDayWeatherHours[i].isDaylight
                    )
                )
            }
        }

        return allHours
    }
}
