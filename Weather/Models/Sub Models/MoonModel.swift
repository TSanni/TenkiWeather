//
//  MoonModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 10/30/24.
//

import Foundation
import WeatherKit


struct MoonModel: Equatable {
    let moonrise: Date?
    let moonset: Date?
    let phase: MoonPhase
    let timezoneIdentifier: String
    
    
    var moonriseTime: String {
        Helper.getReadableHourAndMinute(date: moonrise, timezoneIdentifier: timezoneIdentifier)
    }
    
    var moonsetTime: String {
        Helper.getReadableHourAndMinute(date: moonset, timezoneIdentifier: timezoneIdentifier)
    }
    
    var moonPhaseImage: String {
        switch phase {
        case .new:
            return "moonphase.new.moon"
        case .waxingCrescent:
            return "moonphase.waxing.crescent"
        case .firstQuarter:
            return "moonphase.first.quarter"
        case .waxingGibbous:
            return "moonphase.waxing.gibbous"
        case .full:
            return "moonphase.full.moon.inverse"
        case .waningGibbous:
            return "moonphase.waning.gibbous"
        case .lastQuarter:
            return "moonphase.last.quarter"
        case .waningCrescent:
            return "moonphase.waning.crescent"
        }
    }
}
