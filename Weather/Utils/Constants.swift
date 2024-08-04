//
//  K.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation
import SwiftUI
import SpriteKit


enum K {
    static let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "googlePlacesApiKey") as! String
    static let privacyPolicyURL = "https://www.termsfeed.com/live/a13a54bd-d22e-4076-9260-29d2f89d4621"
    static let tileCornerRadius: CGFloat = 20
    static let legalAttributionURL = "https://weatherkit.apple.com/legal-attribution.html"

    struct UserDefaultKeys {
        static let unitTemperatureKey = "UnitTemperature"
        static let unitDistanceKey = "UnitDistance"
        static let timePreferenceKey = "24HourTime"
    }

    struct LocationDictionaryKeysConstants {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let timezone = "timezone"
        static let temperature = "temperature"
        static let date = "date"
        static let symbol = "symbol"
        static let weatherCondition = "weatherCondition"
        static let unitTemperature = "unitTemperature"
        static let weatherAlert = "weatherAlert"
    }
    
    struct TemperatureUnitsConstants {
        static let fahrenheit = "Fahrenheit"
        static let celsius = "Celsius"
        static let kelvin = "Kelvin"
    }
    
    struct DistanceUnitsConstants {
        static let mph = "miles"
        static let kiloPerHour = "kilometer"
        static let meterPerSecond = "meters"
    }
    
    struct TimeConstants {
        static let oneHourInSeconds = 3600.0
        static let sevenHoursInSeconds = 25000.0
        static let twentyFourHoursInSeconds = 86400.0
        static let fifteenHours = 15
        static let twentyFourHours = 24
        static let hourOnly = "h a" // Ex) 7 AM
        static let hourOnlyMilitary = "HH a" // Ex) 13 PM
        static let monthDayHourMinute = "MMM dd, h:mm a" // Ex: Jul 7, 10:08 PM
        static let monthDayHourMinuteMilitary = "MMM dd, HH:mm a" // Ex: Jul 7, 13:08 PM
        static let dayOfWeekAndDate = "EEEE, MMM d" // Ex: Tuesday, July 7
        static let hourAndMinute = "h:mm a" // Ex: 12:07 PM
        static let hourAndMinuteMilitary = "HH:mm a" // Ex: 12:07 PM

    }
    
    struct ColorsConstants {
        static let goodLightTheme = Color(uiColor: #colorLiteral(red: 0.9607837796, green: 0.9607847333, blue: 0.9822904468, alpha: 1))
        static let properBlack = Color(uiColor: #colorLiteral(red: 0.149019599, green: 0.149019599, blue: 0.149019599, alpha: 1))
        static let goodDarkTheme = Color(uiColor: #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1))
        static let sunMaxColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3699404597, blue: 0.5337731242, alpha: 1))
        static let moonAndStarsColor = Color(uiColor: #colorLiteral(red: 0.2117647059, green: 0.3294117647, blue: 0.5254901961, alpha: 1))
        static let cloudMoonColor = Color(uiColor: #colorLiteral(red: 0.2392156863, green: 0.2666666667, blue: 0.4392156863, alpha: 1))
        static let cloudSunColor = Color(uiColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        static let foggy = Color(uiColor: #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1))
        static let cloudSunRainColor = Color(uiColor: #colorLiteral(red: 0.1450087726, green: 0.5186601877, blue: 0.8773562908, alpha: 1))
        static let cloudMoonRainColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1))
        static let cloudBoltColor = Color(uiColor: #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1))
        static let cloudBoltRainColor = Color(uiColor: #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1))
        static let wind = Color(uiColor: #colorLiteral(red: 0.3438811302, green: 0.6744567752, blue: 0.9567326903, alpha: 1))
        static let haze = Color(uiColor: #colorLiteral(red: 0.6361310482, green: 0.6071113944, blue: 0.5944020152, alpha: 1))
        static let cloudSnow = Color(uiColor: #colorLiteral(red: 0.3795131445, green: 0.7058345675, blue: 0.8753471971, alpha: 1))
        static let precipitationBlue = Color(uiColor: #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1))
        static let tenDayBarColor = Color(uiColor: #colorLiteral(red: 0.09803921569, green: 0.3333333333, blue: 0.4078431373, alpha: 1))
        static let darkRed = Color(uiColor: #colorLiteral(red: 0.6502581835, green: 0.08077467233, blue: 0.02964879759, alpha: 1))
        static let lightPink = Color(uiColor: #colorLiteral(red: 1, green: 0.7621075511, blue: 0.7261560559, alpha: 1))
        static let maroon = Color(uiColor: #colorLiteral(red: 0.4117647059, green: 0.003921568627, blue: 0.01960784314, alpha: 1))
        static let prussianBlue = Color(uiColor: #colorLiteral(red: 0.003921568627, green: 0.2, blue: 0.3294117647, alpha: 1))
        
        
        
    }
}
