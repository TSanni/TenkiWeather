//
//  SunModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

//MARK: - Sun Data Model: Will be used in multiple models
struct SunModel: Equatable {
    let sunrise: Date?
    let sunset: Date?
    let civilDawn: Date?
    let solarNoon: Date?
    let civilDusk: Date?
    let timezoneIdentifier: String
    
    var sunriseTime: String {
        Helper.getReadableHourAndMinute(date: sunrise, timezoneIdentifier: timezoneIdentifier)
    }
    
    var sunsetTime: String {
        Helper.getReadableHourAndMinute(date: sunset, timezoneIdentifier: timezoneIdentifier)
    }
    
    var dawn: String {
        Helper.getReadableHourAndMinute(date: civilDawn, timezoneIdentifier: timezoneIdentifier)
    }
    
    var solarNoonTime: String {
        Helper.getReadableHourAndMinute(date: solarNoon, timezoneIdentifier: timezoneIdentifier)
    }
    
    var dusk: String {
        Helper.getReadableHourAndMinute(date: civilDusk, timezoneIdentifier: timezoneIdentifier)
    }
    
    var duskDescription: String {
        return "Dusk: \(Helper.getReadableHourAndMinute(date: civilDusk, timezoneIdentifier: timezoneIdentifier))"
    }
    
    var dawnDescription: String {
        return "Dawn: \(Helper.getReadableHourAndMinute(date: civilDawn, timezoneIdentifier: timezoneIdentifier))"
    }
}
