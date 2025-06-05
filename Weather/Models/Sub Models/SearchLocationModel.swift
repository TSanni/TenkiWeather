//
//  SearchLocationModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/31/24.
//

import Foundation

struct SearchLocationModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let timeZoneIdentifier: String
    let temperature: String
    let date: String
    let symbol: String
    let weatherCondition: String
    let weatherAlert: Bool
    let timezone: Int
}
