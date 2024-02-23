//
//  WeatherManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/20/23.
//

import Foundation
import WeatherKit


protocol WeatherServiceProtocol {
    func getWeather(latitude: Double, longitude: Double, timezone: Int) async throws -> Weather?
    
    func getTodayWeather(current: CurrentWeather, dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> TodayWeatherModel
    
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> [DailyWeatherModel]
    
    func getWeatherAlert(optionalWeatherAlert: [WeatherAlert]?) -> WeatherAlertModel?
}


actor WeatherManager: WeatherServiceProtocol {
    static let shared = WeatherManager()
  
    func getWeather(latitude: Double, longitude: Double, timezone: Int) async throws -> Weather? {
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
         let hourlyWeatherStartingFromNow = hourlyWeather.filter({ hourlyWeatherItem in
            return hourlyWeatherItem.date.timeIntervalSinceNow >= -3600
        })
        
        var hourlyTemperatures: [HourlyWeatherModel] = []
                
        /// Weather data for wind
        let windDetailsInfo = WindData(
            speed: current.wind.speed,
            compassDirection: current.wind.compassDirection
        )
        
        /// Weather data for sun events
        let sunData = SunData(
            sunrise: dailyWeather[0].sun.sunrise,
            sunset: dailyWeather[0].sun.sunset,
            civilDawn: dailyWeather[0].sun.civilDawn,
            solarNoon: dailyWeather[0].sun.solarNoon,
            civilDusk: dailyWeather[0].sun.civilDusk,
            timezone: timezoneOffset
        )
        
        /// 12 hour forecast data for the Wind and temperatures
        for i in 0..<K.Time.twentyFourHours {
            
            let windData =  WindData(
                speed: hourlyWeatherStartingFromNow[i].wind.speed,
                compassDirection: hourlyWeatherStartingFromNow[i].wind.compassDirection
            )
            
            hourlyTemperatures.append(
                HourlyWeatherModel(
                    temperature: hourlyWeatherStartingFromNow[i].temperature, 
                    wind: windData,
                    date: hourlyWeatherStartingFromNow[i].date,
                    precipitationChance: hourlyWeatherStartingFromNow[i].precipitationChance, 
                    symbol: hourlyWeatherStartingFromNow[i].symbolName,
                    timezone: timezoneOffset
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

        let sunDetails = SunData(
            sunrise: tomorrowWeather.sun.sunrise,
            sunset: tomorrowWeather.sun.sunset,
            civilDawn: tomorrowWeather.sun.civilDawn,
            solarNoon: tomorrowWeather.sun.solarNoon,
            civilDusk: tomorrowWeather.sun.civilDusk,
            timezone: timezoneOffset
        )
        
        let tomorrowsWindData = WindData(
            speed: tomorrowWeather.wind.speed,
            compassDirection: tomorrowWeather.wind.compassDirection
        )
        
        let tomorrowsWeather = DailyWeatherModel(
            highTemperature: tomorrowWeather.highTemperature,
            lowTemperature: tomorrowWeather.lowTemperature,
            precipitation: tomorrowWeather.precipitation,
            precipitationChance: tomorrowWeather.precipitationChance,
            snowfallAmount: tomorrowWeather.snowfallAmount,
            moon: nil,
            sun: sunDetails,
            wind: tomorrowsWindData,
            date: tomorrowWeather.date,
            condition: tomorrowWeather.condition,
            uvIndexValue: tomorrowWeather.uvIndex.value,
            uvIndexCategory: tomorrowWeather.uvIndex.category,
            symbolName: tomorrowWeather.symbolName,
            precipitationAmount: tomorrowWeather.precipitationAmount,
            hourlyWeather: hourlyWeatherForTomorrow,
            timezone: timezoneOffset
        )
        
        return tomorrowsWeather

    }

    
    //MARK: - Get the Daily Weather
    func getDailyWeather(dailyWeather: Forecast<DayWeather>, hourlyWeather: Forecast<HourWeather>, timezoneOffset: Int) -> [DailyWeatherModel] {

        var daily: [DailyWeatherModel] = []

        for day in 0..<dailyWeather.count {
            
            let sunData = SunData(
                sunrise: dailyWeather[day].sun.sunrise,
                sunset: dailyWeather[day].sun.sunset,
                civilDawn: dailyWeather[day].sun.civilDawn,
                solarNoon: dailyWeather[day].sun.solarNoon,
                civilDusk: dailyWeather[day].sun.civilDusk,
                timezone: timezoneOffset
            )
            
            let windDetails = WindData(
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
                    snowfallAmount: dailyWeather[day].snowfallAmount,
                    moon: dailyWeather[day].moon,
                    sun: sunData,
                    wind: windDetails,
                    date: dailyWeather[day].date,
                    condition: dailyWeather[day].condition,
                    uvIndexValue: dailyWeather[day].uvIndex.value,
                    uvIndexCategory: dailyWeather[day].uvIndex.category,
                    symbolName: dailyWeather[day].symbolName,
                    precipitationAmount: dailyWeather[day].precipitationAmount,
                    hourlyWeather: hourlyTempsForDay,
                    timezone: timezoneOffset
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
        var twentyfourHours: [HourlyWeatherModel] = []
        
        
        /// Gets all hourly forecasts starting with 7AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= day.date.advanced(by: K.Time.sevenHoursInSeconds)
        })
        

        
        for i in 0..<K.Time.twentyFourHours {
            
            let windData = WindData(
                speed: nextDayWeatherHours[i].wind.speed,
                compassDirection: nextDayWeatherHours[i].wind.compassDirection
            )
            
            twentyfourHours.append(
                HourlyWeatherModel(
                    temperature: nextDayWeatherHours[i].temperature, 
                    wind: windData,
                    date: nextDayWeatherHours[i].date,
                    precipitationChance: nextDayWeatherHours[i].precipitationChance, 
                    symbol: nextDayWeatherHours[i].symbolName,
                    timezone: timezoneOffset
                )
            )
        }
        
        return twentyfourHours
        
    }
}



//MARK: - Public functions
extension WeatherManager {

    /// Takes a CompassDirection and returns a Double which indicates the angle the current compass direction.
    /// One use can be to properly set rotation effects on views
   nonisolated func getRotation(direction: Wind.CompassDirection) -> Double {
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
   nonisolated func getImage(imageName: String) -> String {
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
