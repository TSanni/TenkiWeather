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
        Helper.getReadableHourAndMinute(date: sunrise, timezoneOffset: timezone)
    }
    
    var sunsetTime: String {
        Helper.getReadableHourAndMinute(date: sunset, timezoneOffset: timezone)
    }
    
    var dawn: String {
        Helper.getReadableHourAndMinute(date: civilDawn, timezoneOffset: timezone)
    }
    
    var solarNoonTime: String {
        Helper.getReadableHourAndMinute(date: solarNoon, timezoneOffset: timezone)
    }
    
    var dusk: String {
        Helper.getReadableHourAndMinute(date: civilDusk, timezoneOffset: timezone)
    }
    
    var duskDescription: String {
        return "Dusk: \(Helper.getReadableHourAndMinute(date: civilDusk, timezoneOffset: timezone))"
    }
    
    var dawnDescription: String {
        return "Dawn: \(Helper.getReadableHourAndMinute(date: civilDawn, timezoneOffset: timezone))"
    }
}
