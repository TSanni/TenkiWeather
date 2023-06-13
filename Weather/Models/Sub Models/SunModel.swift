//
//  SunModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

//MARK: - Sun Data Model: Will be used in multiple models
struct SunData {
    let sunrise: String
    let sunset: String
    let dawn: String
    let solarNoon: String
    let dusk: String
    
    
    /// Holder data for Sun data
    static let sunDataHolder = SunData(sunrise: "-", sunset: "-", dawn: "-", solarNoon: "-", dusk: "-")
}
