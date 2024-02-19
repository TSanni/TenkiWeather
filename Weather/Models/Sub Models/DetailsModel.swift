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
    let dewPoint: Measurement<UnitTemperature>
    let pressure: Measurement<UnitPressure>
    let pressureTrend: PressureTrend
    let uvIndexCategory: UVIndex.ExposureCategory
    let uvIndexValue: Int
    let visibility: Measurement<UnitLength>
    let sunData: SunData?

    var humidityPercentage: String {
        humidity.formatted(.percent)
    }
    
    var dewPointDescription: String {
        let dewPointTemperature = dewPoint.converted(to: getUnitTemperature())
        let temperatureValueOnly = convertNumberToZeroFloatingPoints(number: dewPointTemperature.value)
        
        return temperatureValueOnly + dewPointTemperature.unit.symbol
    }
    
    var pressureString: String {
        let pressure = pressure.converted(to: .inchesOfMercury)
        let value = convertNumberToTwoFloatingPoints(number: pressure.value)
        let symbol = pressure.unit.symbol
        return value + "\n" + symbol
    }
    
    var pressureDescription: String {
        switch pressureTrend {
        case .rising:
            return "The pressure is rising."
        case .falling:
            return "The pressure is falling."
        case .steady:
            return "The pressure is not changing."
        default:
            return "No pressure data"
        }
    }
    
    var pressureValue: Double {
        let pressure = pressure.converted(to: .inchesOfMercury)
        let value = pressure.value
        return value
    }
    
    var visibilityValue: String {
        let unit = getUnitLength()
        let visibility = visibility.converted(to: unit)
        let formattedVisibilityValue = convertNumberToZeroFloatingPoints(number: visibility.value)
        let symbol = visibility.unit.symbol
        return formattedVisibilityValue + symbol
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

    // TODO: Might have to edit these values later. Check for proper visibility scale
    var visiblityDescription: String {
        let visibilityValue = visibility.converted(to: .meters).value
        
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



    
    /// Holder data for today's current weather details
    static let detailsDataHolder = DetailsModel(
        humidity: 0.5, 
        dewPoint: Measurement(value: 50, unit: .fahrenheit),
        pressure: Measurement(value: 20, unit: .inchesOfMercury),
        pressureTrend: .rising, uvIndexCategory: .extreme,
        uvIndexValue: 7,
        visibility: Measurement(value: 5000, unit: .meters),
        sunData: SunData.sunDataHolder
    )
}


extension DetailsModel {
    private func getUnitSpeed() -> UnitSpeed {
        let chosenUnitDistance = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitDistanceKey)
        
        switch chosenUnitDistance {
        case  K.DistanceUnits.mph:
            return .milesPerHour
        case K.DistanceUnits.kiloPerHour:
            return .kilometersPerHour
        case K.DistanceUnits.meterPerSecond:
            return .metersPerSecond
        default:
            return .milesPerHour
        }
    }
    
    private func getUnitLength() -> UnitLength {
       let unitSpeed = getUnitSpeed()
       
       switch unitSpeed {
           case .milesPerHour:
               return .miles
           case .kilometersPerHour:
               return .kilometers
           case .metersPerSecond:
               return .meters
           default:
               return .miles
       }
   }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.0f", number)
        return convertedStringNumber
    }
    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToTwoFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.2f", number)
        return convertedStringNumber
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    private func getUnitTemperature() -> UnitTemperature {
        let savedUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch savedUnitTemperature {
        case K.TemperatureUnits.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnits.celsius:
            return .celsius
        case   K.TemperatureUnits.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
}
