//
//  WeatherAlertModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/25/23.
//

import Foundation
import WeatherKit
import SwiftUI

struct WeatherAlertModel {
    let detailsURL: URL
    let region: String
    let severity: WeatherSeverity
    let source: String
    let summary: String
    
    
    
    var severityColor: Color {
        switch severity {
            case .minor:
                return Color.yellow
            case .moderate:
                return Color.orange
            case .severe:
                return Color.red
            case .extreme:
                return Color.purple
            case .unknown:
                return Color.gray
            @unknown default:
                return Color.gray
        }
    }
}
