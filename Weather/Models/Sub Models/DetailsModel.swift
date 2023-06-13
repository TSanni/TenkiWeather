//
//  DetailsModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation

//MARK: - Details Model : Will be part of main model
struct DetailsModel {
    let humidity: String?
    let dewPoint: String?
    let pressure: String?
    let uvIndex: String
    let visibility: String?
    let sunData: SunData?

    /// Holder data for today's current weather details
    static let detailsDataHolder = DetailsModel(humidity: "-", dewPoint: "-", pressure: "-", uvIndex: "-", visibility: "-", sunData: SunData.sunDataHolder)
}
