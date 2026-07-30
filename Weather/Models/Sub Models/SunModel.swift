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
    /// Signal from an HourWeather sample (e.g. the hour closest to solar
    /// noon) used to tell polar day (sun never sets) apart from polar
    /// night (sun never rises) when sunrise/sunset are both nil. Leave
    /// nil if that signal isn't available — the UI falls back to a
    /// neutral "unavailable" message in that case. Defaulted so existing
    /// call sites that don't pass it keep compiling unchanged.
    let isDaylight: Bool?

    init(
        sunrise: Date?,
        sunset: Date?,
        civilDawn: Date?,
        solarNoon: Date?,
        civilDusk: Date?,
        timezoneIdentifier: String,
        isDaylight: Bool? 
    ) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.civilDawn = civilDawn
        self.solarNoon = solarNoon
        self.civilDusk = civilDusk
        self.timezoneIdentifier = timezoneIdentifier
        self.isDaylight = isDaylight
    }

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
