//
//  SunModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

//MARK: - Sun Data Model: Will be used in multiple models
struct SunData {
    let sunrise: Date?
    let sunset: Date?
    let civilDawn: Date?
    let solarNoon: Date?
    let civilDusk: Date?
    let timezone: Int
    
    var sunriseTime: String {
        getReadableHourAndMinute(date: sunrise, timezoneOffset: timezone)
    }
    
    var sunsetTime: String {
        getReadableHourAndMinute(date: sunset, timezoneOffset: timezone)
    }
    
    var dawn: String {
        getReadableHourAndMinute(date: civilDawn, timezoneOffset: timezone)
    }
    
    var solarNoonTime: String {
        getReadableHourAndMinute(date: solarNoon, timezoneOffset: timezone)
    }
    
    var dusk: String {
        getReadableHourAndMinute(date: civilDusk, timezoneOffset: timezone)
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
    
    
    /// Holder data for Sun data
    static let sunDataHolder = SunData(
        sunrise: Date.now,
        sunset: Date.now,
        civilDawn: Date.now,
        solarNoon: Date.now,
        civilDusk: Date.now,
        timezone: 0
    )
}
