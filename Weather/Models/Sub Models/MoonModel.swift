//
//  MoonModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 10/30/24.
//

import Foundation
import WeatherKit


struct MoonModel {
    let moonrise: Date?
    let moonset: Date?
    let phase: MoonPhase
    let timezone: Int
    
    
    var moonriseTime: String {
        Helper.getReadableHourAndMinute(date: moonrise, timezoneOffset: timezone)
    }
    
    var moonsetTime: String {
        Helper.getReadableHourAndMinute(date: moonset, timezoneOffset: timezone)
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
