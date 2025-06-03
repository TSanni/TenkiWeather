//
//  WeatherAlertModel+Placeholder.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/3/25.
//

import Foundation

struct WeatherAlertModelPlaceholder {
    static let weatherAlertHolder = WeatherAlertModel(
        detailsURL: URL(string: "https://www.google.com")!,
        region: nil,
        severity: .extreme,
        source: "unknown source",
        summary: "unknown summary"
    )
}
