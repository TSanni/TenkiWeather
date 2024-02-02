//
//  K.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation
import SwiftUI


struct K {
//    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey")
    static let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "googlePlacesApiKey") as! String
    
    static let privacyPolicyURL = "https://www.termsfeed.com/live/a13a54bd-d22e-4076-9260-29d2f89d4621"
    
    static let tileCornerRadius: CGFloat = 20

    struct UserDefaultKeys {
        static let unitTemperatureKey = "UnitTemperature"
        static let unitDistanceKey = "UnitDistance"
    }

    struct LocationDictionaryKeys {
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let timezone = "timezone"
        static let temperature = "temperature"
        static let date = "date"
        static let symbol = "symbol"
        static let weatherCondition = "weatherCondition"
    }
    
    struct TemperatureUnits {
        static let fahrenheit = "Fahrenheit"
        static let celsius = "Celsius"
        static let kelvin = "Kelvin"
    }
    
    struct DistanceUnits {
        static let mph = "Miles per hour"
        static let kiloPerHour = "Kilometers per hour"
        static let meterPerSecond = "Meters per second"
    }
    
    struct Time {
        static let oneHourInSeconds = 3600.0
        static let sevenHoursInSeconds = 25000.0
        static let twentyFourHoursInSeconds = 86400.0
        static let fifteenHours = 15
        static let twentyFourHours = 24
    }
    
    
    // Can't use Enum because the WeatherKit API is returning Strings for the Symbols
    struct Symbol {
        
        static let sunMax = "sun.max"
        static let moon = "moon"
        static let moonStars = "moon.stars"
        static let cloudSun = "cloud.sun"
        static let cloudMoon = "cloud.moon"
        static let cloud = "cloud"
        static let cloudRain = "cloud.rain"
        static let cloudSunRain = "cloud.sun.rain"
        static let cloudMoonRain = "cloud.moon.rain"
        static let cloudBolt = "cloud.bolt"
        static let snowflake = "snowflake"
        static let cloudFog = "cloud.fog"
        static let sunMin = "sun.min" //
        static let cloudBoltRain = "cloud.bolt.rain"
        static let cloudDrizzle = "cloud.drizzle" //
        static let cloudSnow = "cloud.snow" //
        static let cloudMoonBolt = "cloud.moon.bolt"
        static let wind = "wind"
        static let sunHaze = "sun.haze"
        static let moonHaze = "moon.haze"
    }
    
    

    
    static func getBackGroundColor(symbol: String) -> Color {
        switch symbol {
        case K.Symbol.sunMax:
            return Color(uiColor: K.Colors.sunMaxColor)
        case K.Symbol.moon:
            return Color(uiColor: K.Colors.moonAndStarsColor)
        case K.Symbol.moonStars:
            return Color(uiColor: K.Colors.moonAndStarsColor)
        case K.Symbol.cloudSun:
            return Color(uiColor: K.Colors.cloudSunColor)
        case K.Symbol.cloudMoon:
            return Color(uiColor: K.Colors.cloudMoonColor)
        case K.Symbol.cloud:
            return Color(uiColor: K.Colors.cloudy)
        case K.Symbol.cloudRain:
            return Color(uiColor: K.Colors.cloudSunRainColor)
        case K.Symbol.cloudSunRain:
            return Color(uiColor: K.Colors.cloudSunRainColor)
        case K.Symbol.cloudMoonRain:
            return Color(uiColor: K.Colors.cloudMoonRainColor)
        case K.Symbol.cloudBolt:
            return Color(uiColor: K.Colors.cloudBoltColor)
        case K.Symbol.snowflake:
            return Color(uiColor: K.Colors.cloudSunColor)
        case K.Symbol.cloudFog:
            return Color(uiColor: K.Colors.cloudy)
        case K.Symbol.cloudBoltRain:
            return Color(uiColor: K.Colors.cloudBoltRainColor)
        case K.Symbol.cloudSnow:
            return Color(uiColor: K.Colors.cloudSnow)
        case K.Symbol.cloudMoonBolt:
            return Color(uiColor: K.Colors.cloudBoltColor)
        case K.Symbol.wind:
            return Color(uiColor: K.Colors.wind)
        case K.Symbol.sunHaze:
            return Color(uiColor: K.Colors.haze)
        case K.Symbol.moonHaze:
            return Color(uiColor: K.Colors.haze)
        default:
            return Color(uiColor: K.Colors.sunMaxColor)
        }
    }
    
    struct Colors {
        static let goodLightTheme = Color(uiColor: #colorLiteral(red: 0.9607837796, green: 0.9607847333, blue: 0.9822904468, alpha: 1))
        static let properBlack = #colorLiteral(red: 0.149019599, green: 0.149019599, blue: 0.149019599, alpha: 1)
        static let goodDarkTheme = Color(uiColor: #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1))

        static let sunMaxColor = #colorLiteral(red: 0.1332838535, green: 0.6956239343, blue: 0.889532268, alpha: 1)
        static let moonAndStarsColor = #colorLiteral(red: 0.5618619323, green: 0.3260331154, blue: 1, alpha: 1)
        static let cloudSunColor = #colorLiteral(red: 0.3795131445, green: 0.7058345675, blue: 0.8753471971, alpha: 1)
        static let cloudMoonColor = #colorLiteral(red: 0.521438539, green: 0.5413015485, blue: 0.8576574922, alpha: 1)
        static let cloudy = #colorLiteral(red: 0.4886933565, green: 0.624339819, blue: 0.7615836859, alpha: 1)
        static let cloudSunRainColor = #colorLiteral(red: 0.1450087726, green: 0.5186601877, blue: 0.8773562908, alpha: 1)
        static let cloudMoonRainColor = #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1)
        static let cloudBoltColor = #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1)
        static let cloudBoltRainColor = #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1)
        static let wind = #colorLiteral(red: 0.3438811302, green: 0.6744567752, blue: 0.9567326903, alpha: 1)
        static let haze = #colorLiteral(red: 0.6361310482, green: 0.6071113944, blue: 0.5944020152, alpha: 1)
        static let cloudSnow = #colorLiteral(red: 0.2117647059, green: 0.3294117647, blue: 0.5254901961, alpha: 1)
                
        static let precipitationBlue = Color(uiColor: #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1))
//        static let precipitationBlue = #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1)
        
        
        static let cloudyBlue = #colorLiteral(red: 0.518604517, green: 0.6436038613, blue: 0.78536731, alpha: 1)
        static let tenDayBarColor = #colorLiteral(red: 0.0978968963, green: 0.3324657381, blue: 0.4080292583, alpha: 1)
        
        static let darkRed = #colorLiteral(red: 0.6502581835, green: 0.08077467233, blue: 0.02964879759, alpha: 1)
        static let lightPink = #colorLiteral(red: 1, green: 0.7621075511, blue: 0.7261560559, alpha: 1)
        static let maroon = #colorLiteral(red: 0.4117647059, green: 0.003921568627, blue: 0.01960784314, alpha: 1)
        static let prussianBlue = #colorLiteral(red: 0.003921568627, green: 0.2, blue: 0.3294117647, alpha: 1)

        
    }
}
