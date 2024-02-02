//
//  WindModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/13/23.
//

import Foundation
import WeatherKit
import SwiftUI

//MARK: - Wind Data Model : Will be part of main model

/// Consists of windSpeed, windDirection, time, windDescriptionForMPH, and readableWindDirection
struct WindData: Identifiable {
    let id = UUID()
    let windSpeed: String
    let windDirection: Wind.CompassDirection
    let time: String?
    let speedUnit: String
    
    /// Computed property uses the wind speed and returns a string description
    var windDescriptionForMPH: String {
        
        if let numWindSpeed = Int(windSpeed) {
            switch numWindSpeed {
                case 1...3:
                    return "Light Air"
                case 4...7:
                    return "Light Breeze"
                case 8...12:
                    return "Gentle Breeze"
                case 13...18:
                    return "Moderate Breeze"
                case 19...24:
                    return "Fresh Breeze"
                case 25...31:
                    return "Strong Breeze"
                case 32...38:
                    return "Near Gale"
                case 39...46:
                    return "Gale"
                case 47...54:
                    return "Strong Gale"
                case 55...63:
                    return "Whole Gale"
                case 64...75:
                    return "Storm Force"
                case 76...1000:
                    return "Hurricane Force"
                default:
                    return "Calm"
            }
        } else {
            return "Unable to get wind data"
        }
    }
    
    
    /// Computed property converts the enum wind directions to a readable string format
    var readableWindDirection: String {
        switch windDirection {
            case .north:
                return "North"
            case .northNortheast:
                return "North Northeast"
            case .northeast:
                return "Northeast"
            case .eastNortheast:
                return "East Northeast"
            case .east:
                return "East"
            case .eastSoutheast:
                return "East Southeast"
            case .southeast:
                return "Southeast"
            case .southSoutheast:
                return "South Southeast"
            case .south:
                return "South"
            case .southSouthwest:
                return "South Southwest"
            case .southwest:
                return "Southwest"
            case .westSouthwest:
                return "West Southwest"
            case .west:
                return "West"
            case .westNorthwest:
                return "West Northwest"
            case .northwest:
                return "Northwest"
            case .northNorthwest:
                return "North Northwest"
        }
    }
    
    var windColor: Color {
        let oldLight = #colorLiteral(red: 0.04400173575, green: 0.5181836486, blue: 0.9972603917, alpha: 1)
        let light = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)

    //    let oldbreeze = #colorLiteral(red: 0.1430673301, green: 0.6491933465, blue: 0.60500741, alpha: 1)
        let breeze = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
        let gale = #colorLiteral(red: 0.9978212714, green: 0.9978941083, blue: 0.5972678661, alpha: 1)
        let strongGale = #colorLiteral(red: 0.9998317361, green: 0.7493718266, blue: 0, alpha: 1)
        let storm = #colorLiteral(red: 1, green: 0.6042675376, blue: 0.395904392, alpha: 1)
        let violentStorm = #colorLiteral(red: 1, green: 0.400586307, blue: 0, alpha: 1)
        let hurricane = #colorLiteral(red: 0.8019552231, green: 0.195156306, blue: 0.004458193202, alpha: 1)
        let unit = WeatherManager.shared.getUnitLength()
        
        if let numWindSpeed = Int(windSpeed) {
           
            
            if unit == .miles { // Wind speed colors for miles
                switch numWindSpeed {
                    case 0...12://
                        return Color(uiColor: light)
                    case 13...31:
                        return Color(uiColor: breeze)
                    case 32...38:
                        return Color(uiColor: gale)
                    case 39...54:
                        return Color(uiColor: strongGale)
                    case 55...63:
                        return Color(uiColor: storm)
                    case 64...72:
                        return Color(uiColor: violentStorm)
                    case 73...500:
                        return Color(uiColor: hurricane)
                    default:
                        return Color(uiColor: light)
                }
            } else if unit == .kilometers { // Wind speed colors for kilometers
                switch numWindSpeed {
                    case 0...19:
                        return Color(uiColor: light)
                    case 20...50:
                        return Color(uiColor: breeze)
                    case 51...61:
                        return Color(uiColor: gale)
                    case 62...87:
                        return Color(uiColor: strongGale)
                    case 88...101:
                        return Color(uiColor: storm)
                    case 102...116:
                        return Color(uiColor: violentStorm)
                    case 117...500:
                        return Color(uiColor: hurricane)
                    default:
                        return Color(uiColor: light)
                }
            } else if unit == .meters { // Wind speed colors for meters
                switch numWindSpeed {
                    case 0...5://
                        return Color(uiColor: light)
                    case 6...13://
                        return Color(uiColor: breeze)
                    case 14...17://
                        return Color(uiColor: gale)
                    case 18...24://
                        return Color(uiColor: strongGale)
                    case 25...28://
                        return Color(uiColor: storm)
                    case 29...32://
                        return Color(uiColor: violentStorm)
                    case 33...500:
                        return Color(uiColor: hurricane)
                    default:
                        return Color(uiColor: light)
                }
            } else { //Knots
                switch numWindSpeed {
                    case 0...10:
                        return Color(uiColor: light)
                    case 6...27:
                        return Color(uiColor: breeze)
                    case 14...33:
                        return Color(uiColor: gale)
                    case 18...47:
                        return Color(uiColor: strongGale)
                    case 25...54:
                        return Color(uiColor: storm)
                    case 29...63:
                        return Color(uiColor: violentStorm)
                    case 64...500:
                        return Color(uiColor: hurricane)
                    default:
                        return Color(uiColor: light)
                }


            }
        } else {
            return Color(uiColor: light)
        }
    }
    
    
    /// Holder data for wind details
    static let windDataHolder: [WindData] = [
        WindData(windSpeed: "10", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "1 AM", speedUnit: "m/s"),
        WindData(windSpeed: "31", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "2 AM", speedUnit: "m/s"),
        WindData(windSpeed: "38", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "3 AM", speedUnit: "m/s"),
        WindData(windSpeed: "54", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "4 AM", speedUnit: "m/s"),
        WindData(windSpeed: "63", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "5 AM", speedUnit: "m/s"),
        WindData(windSpeed: "72", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "6 AM", speedUnit: "m/s"),
        WindData(windSpeed: "10", windDirection: Wind.CompassDirection(rawValue: "-") ?? Wind.CompassDirection.north, time: "7 AM", speedUnit: "m/s"),
    ]
}
