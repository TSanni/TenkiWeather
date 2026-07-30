//
//  SunModel+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/4/24.
//

import Foundation

struct SunModelPlaceholder {
    /// Holder data for Sun data
    static let sunDataHolder = SunModel(
        sunrise: nil,
        sunset: nil,
        civilDawn: Date.now,
        solarNoon: Date.now,
        civilDusk: Date.now,
        timezoneIdentifier: K.defaultTimezoneIdentifier,
        isDaylight: false
    )
}
