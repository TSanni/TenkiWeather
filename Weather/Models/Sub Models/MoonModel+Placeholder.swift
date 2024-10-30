//
//  MoonModel+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 10/30/24.
//

import Foundation

struct MoonModelPlaceholder {
    /// Holder data for Moon data
    static let moonDataHolder = MoonModel(
        moonrise: Date.now,
        moonset: Date.now,
        phase: .full,
        timezone: 0
    )
}
