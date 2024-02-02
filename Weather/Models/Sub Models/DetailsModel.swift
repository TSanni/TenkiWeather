//
//  DetailsModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation
import WeatherKit
import SwiftUI


//MARK: - Details Model : Will be part of main model
struct DetailsModel {
    let humidity: Double
    let dewPoint: String?
    let pressure: String?
    let uvIndexCategory: UVIndex.ExposureCategory
    let uvIndexValue: Int
    let visibility: String?
    let sunData: SunData?
    let visibilityValue: Double?
    let pressureTrend: PressureTrend?
    let pressureValue: Double
    
    
    var visiblityDescription: String {
        guard let visibilityValue = visibilityValue else { return "No value" }
        
        switch visibilityValue {
        case 0...926:
            return "Very poor visibility."
        case 927...3704:
            return "Weather conditions are affecting visibility."
        case 3705...9260:
            return "Weather conditions are affecting visibility."
        case 9261...500000:
            return "Perfectly clear view."
            
            
        default:
            return "Unable to determine visibility."
        }
    }
    
    
    var humidityPercentage: String {
        humidity.formatted(.percent)
    }
    
    var dewPointDescription: String {
        dewPoint ?? ""
    }
    
    var uvIndexCategoryDescription: String {
        uvIndexCategory.description
    }
    
    var uvIndexValueDescription: String {
        uvIndexValue.description
    }
    
    var uvIndexActionRecommendation: String {
        switch uvIndexCategory {
        case .low:
            return "Minimal sun protection needed."
        case .moderate:
            return "Use Sun Protection."
        case .high:
            return "Extra sun protection needed."
        case .veryHigh:
            return "Extra sun protection needed."
        case .extreme:
            return "Extra sun protection needed."
        }
    }
    
    var uvIndexColor: Color {
        switch uvIndexCategory {
        case .low:
            return Color.green
        case .moderate:
            return Color.orange
        case .high:
            return Color.red
        case .veryHigh:
            return Color.red
        case .extreme:
            return Color.red
        }
    }

    var pressureString: String {
        pressure ?? "Pressure unavailable"
    }
    
    var pressureDescription: String {
        switch pressureTrend {
        case .rising:
            return "The pressure is rising."
        case .falling:
            return "The pressure is falling."
        case .steady:
            return "The pressure is not changing."
        case nil:
            return "No pressure data"
        default:
            return "No pressure data"
        }
    }
    

    
    
    
    /// Holder data for today's current weather details
    static let detailsDataHolder = DetailsModel(humidity: 0.5, dewPoint: "-", pressure: "-", uvIndexCategory: .extreme, uvIndexValue: 7, visibility: "-", sunData: SunData.sunDataHolder, visibilityValue: 100, pressureTrend: .rising, pressureValue: 30)
}
