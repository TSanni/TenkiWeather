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
        
        
        var hourlyWind: [WindData] = []
        var hourlyTemperatures: [HourlyTemperatures] = []
        
        
        /// Weather data for Current details card
        let currentDetailsCardInfo = DetailsModel(
            humidity: current.humidity,
            dewPoint: String(format: "%.0f", current.dewPoint.converted(to: getUnitTemperature()).value) + current.dewPoint.converted(to: getUnitTemperature()).unit.symbol,
            pressure: getReadableMeasurementPressure(measurement: current.pressure.converted(to: .inchesOfMercury)),
            uvIndexCategory: current.uvIndex.category,
            uvIndexValue: current.uvIndex.value,
            visibility: getReadableMeasurementLengths(measurement: current.visibility.converted(to: getUnitLength())),
            sunData: nil,
            visibilityValue: current.visibility.value,
            pressureTrend: current.pressureTrend,
            pressureValue: current.pressure.converted(to: .inchesOfMercury).value
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
            sunrise: dailyWeather[0].sun.sunrise,
            sunset: dailyWeather[0].sun.sunset,
            civilDawn: dailyWeather[0].sun.civilDawn,
            solarNoon: dailyWeather[0].sun.solarNoon,
            civilDusk: dailyWeather[0].sun.civilDusk,
            timezone: timezoneOffset
        )
        
        
        
        /// 12 hour forecast data for the Wind and temperatures
        for i in 0..<K.Time.twentyFourHours {
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
            apparentTemperature: current.apparentTemperature, 
            temperature: current.temperature, 
            date: current.date,
            highTemperature: dailyWeather[0].highTemperature,
            lowTemperature: dailyWeather[0].lowTemperature,
            symbol: current.symbolName,
            condition: current.condition,
            precipitationChance: dailyWeather[0].precipitationChance,
            currentDetails: currentDetailsCardInfo,
            todayWind: windDetailsInfo,
            todayHourlyWind: hourlyWind,
            sunData: sunData,
            isDaylight: current.isDaylight,
            hourlyTemperatures: hourlyTemperatures,
            timezeone: timezoneOffset
            
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

        
        for hour in 0..<K.Time.twentyFourHours {
            tomorrow12HourForecast.append(nextDayWeatherHours[hour])
            
        }
        
        for hour in 0..<K.Time.twentyFourHours {
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
            sunrise: tomorrowWeather.sun.sunrise,
            sunset: tomorrowWeather.sun.sunset,
            civilDawn: tomorrowWeather.sun.civilDawn,
            solarNoon: tomorrowWeather.sun.solarNoon,
            civilDusk: tomorrowWeather.sun.civilDusk,
            timezone: timezoneOffset
        )
        
        let tomorrowDetails = DetailsModel(
            humidity: 0,
            dewPoint: nil,
            pressure: nil,
            uvIndexCategory: tomorrowWeather.uvIndex.category,
            uvIndexValue: tomorrowWeather.uvIndex.value,
            visibility: "",
            sunData: sunDetails,
            visibilityValue: nil,
            pressureTrend: nil,
            pressureValue: 0
        )
        
        let tomorrowWind = WindData(
            windSpeed: String(format: "%.0f", tomorrowWeather.wind.speed.converted(to: getUnitSpeed()).value),
            windDirection: tomorrowWeather.wind.compassDirection,
            time: nil,
            speedUnit: tomorrowWeather.wind.speed.converted(to: getUnitSpeed()).unit.symbol
        )
        
        let tomorrowsWeather = TomorrowWeatherModel(
            highTemperature: tomorrowWeather.highTemperature,
            lowTemperature: tomorrowWeather.lowTemperature,
            precipitation: tomorrowWeather.precipitation,
            precipitationChance: tomorrowWeather.precipitationChance,
            snowfallAmount: tomorrowWeather.snowfallAmount,
            moonEvents: nil,
            sunData: sunDetails,
            tomorrowWind: tomorrowWind,
            date: tomorrowWeather.date,
            condition: tomorrowWeather.condition,
            uvIndexValue: tomorrowWeather.uvIndex.value,
            uvIndexCategory: tomorrowWeather.uvIndex.category,
            symbolName: tomorrowWeather.symbolName,
            precipitationAmount: tomorrowWeather.precipitationAmount,
            tomorrowDetails: tomorrowDetails,
            tomorrowHourlyWind: tomorrowHourlyWind,
            hourlyTemperatures: tomorrowHourlyTemperatures,
            timezone: timezoneOffset
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
                sunrise: dailyWeather[day].sun.sunrise,
                sunset: dailyWeather[day].sun.sunset,
                civilDawn: dailyWeather[day].sun.civilDawn,
                solarNoon: dailyWeather[day].sun.solarNoon,
                civilDusk: dailyWeather[day].sun.civilDusk,
                timezone: timezoneOffset
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
    private func getHourlyWeatherForDay(day: DayWeather, hours: Forecast<HourWeather>, timezoneOffset: Int) -> [HourlyTemperatures] {
        var fifteenHours: [HourlyTemperatures] = []
        
        
        /// Gets all hourly forecasts starting with 7AM that day
        let nextDayWeatherHours = hours.filter({ hourWeather in
            /// Weather starts at 12AM on the day. Use .advanced method to advance time by 25000 seconds (7 hours)
            return hourWeather.date >= day.date.advanced(by: K.Time.sevenHoursInSeconds)
        })
        

        
        for i in 0..<K.Time.fifteenHours {
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
    
    
    /// Takes a UnitPressure measurement and converts it to a readable format by limiting result to two floating numbers.
    /// Returns a String of that format
    private func getReadableMeasurementPressure(measurement: Measurement<UnitPressure>) -> String {
        return String(format: "%.2f", measurement.value) + " " + measurement.unit.symbol
        
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
    
    
     func getUnitLength() -> UnitLength {
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
        let chosenUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch chosenUnitTemperature {
        case K.TemperatureUnits.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnits.celsius:
            return .celsius
        case   K.TemperatureUnits.kelvin:
            return .kelvin
        default:
            print("CAN'T DETERMINE UNIT TEMPERATURE")
            return .fahrenheit
        }
        

    }
    
    
    private func getUnitSpeed() -> UnitSpeed {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitDistanceKey)
        
        switch chosenUnitDistance {
        case  K.DistanceUnits.mph:
            return .milesPerHour
        case K.DistanceUnits.kiloPerHour:
            return .kilometersPerHour
        case K.DistanceUnits.meterPerSecond:
            return .metersPerSecond
        default:
            print("CAN'T DETERMINE UNIT SPEED")
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
            case "snow":
                return imageName
                
            default:
                return imageName + ".fill"
        }
    }
}
