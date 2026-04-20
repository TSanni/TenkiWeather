//
//  WindModel+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/4/24.
//

import Foundation
import WeatherKit


struct WindModelPlaceholder {
    /// Holder data for wind details
    
    static var windDataHolder: [WindModel] {
        var arr: [WindModel] = []

        for _ in 0..<12 {
            arr.append(WindModel(speed: Measurement(value: Double.random(in: 1..<50), unit: .milesPerHour), compassDirection: .north))
        }
        
        return arr
    }
}
