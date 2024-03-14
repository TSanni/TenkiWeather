//
//  K.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation
import SwiftUI
import SpriteKit


struct K {
    static let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "googlePlacesApiKey") as! String
    static let privacyPolicyURL = "https://www.termsfeed.com/live/a13a54bd-d22e-4076-9260-29d2f89d4621"
    static let tileCornerRadius: CGFloat = 20
    static let legalAttributionURL = "https://weatherkit.apple.com/legal-attribution.html"

    struct UserDefaultKeys {
        static let unitTemperatureKey = "UnitTemperature"
        static let unitDistanceKey = "UnitDistance"
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
        static let monthDayHourMinuteFormat = "MMM dd, h:mm a"
    }
    
    // Can't use Enum because the WeatherKit API is returning Strings for the Symbols
    struct SymbolConstants {
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
        static let cloudHeavyRain = "cloud.heavyrain"
        static let snow = "snow"
    }
    

    static func getScene(symbol: String) -> SKScene? {
        switch symbol {
        case K.SymbolConstants.snowflake:
            return SnowScene()
        case K.SymbolConstants.cloudSnow:
            return SnowScene()
        case K.SymbolConstants.snow:
            return SnowScene()
        case K.SymbolConstants.cloudRain:
            return RainScene()
        case K.SymbolConstants.cloudSunRain:
            return RainScene()
        case K.SymbolConstants.cloudBoltRain:
            return RainScene()
        case K.SymbolConstants.cloudMoonRain:
            return RainScene()
        case K.SymbolConstants.cloudDrizzle:
            return RainScene()
        case K.SymbolConstants.cloudHeavyRain:
            return RainScene()
        default:
            return nil
        }
    }
    
    static func getBackGroundColor(symbol: String) -> Color {
        switch symbol {
        case K.SymbolConstants.sunMax:
            return Color(uiColor: K.ColorsConstants.sunMaxColor)
        case K.SymbolConstants.moon:
            return Color.indigo
        case K.SymbolConstants.moonStars:
            return Color.indigo
        case K.SymbolConstants.cloudSun:
            return Color(uiColor: K.ColorsConstants.cloudSunColor)
        case K.SymbolConstants.cloudMoon:
            return Color(uiColor: K.ColorsConstants.cloudMoonColor)
        case K.SymbolConstants.cloud:
            return Color(uiColor: K.ColorsConstants.cloudy)
        case K.SymbolConstants.cloudRain:
            return Color(uiColor: K.ColorsConstants.cloudSunRainColor)
        case K.SymbolConstants.cloudSunRain:
            return Color(uiColor: K.ColorsConstants.cloudSunRainColor)
        case K.SymbolConstants.cloudMoonRain:
            return Color(uiColor: K.ColorsConstants.cloudMoonRainColor)
        case K.SymbolConstants.cloudBolt:
            return Color(uiColor: K.ColorsConstants.cloudBoltColor)
        case K.SymbolConstants.snowflake:
            return Color(uiColor: K.ColorsConstants.cloudSunColor)
        case K.SymbolConstants.cloudFog:
            return Color(uiColor: K.ColorsConstants.cloudy)
        case K.SymbolConstants.cloudBoltRain:
            return Color(uiColor: K.ColorsConstants.cloudBoltRainColor)
        case K.SymbolConstants.cloudSnow:
            return Color(uiColor: K.ColorsConstants.cloudSnow)
        case K.SymbolConstants.cloudMoonBolt:
            return Color(uiColor: K.ColorsConstants.cloudBoltColor)
        case K.SymbolConstants.wind:
            return Color(uiColor: K.ColorsConstants.wind)
        case K.SymbolConstants.sunHaze:
            return Color(uiColor: K.ColorsConstants.haze)
        case K.SymbolConstants.moonHaze:
            return Color(uiColor: K.ColorsConstants.haze)
        case K.SymbolConstants.cloudHeavyRain:
            return Color(uiColor: K.ColorsConstants.cloudMoonRainColor)
        case K.SymbolConstants.cloudDrizzle:
            return Color(uiColor: K.ColorsConstants.cloudSunRainColor)
        case K.SymbolConstants.snow:
            return Color(uiColor: K.ColorsConstants.cloudSnow)
        default:
            return Color(uiColor: K.ColorsConstants.sunMaxColor)
        }
    }
    
    struct ColorsConstants {
        static let goodLightTheme = Color(uiColor: #colorLiteral(red: 0.9607837796, green: 0.9607847333, blue: 0.9822904468, alpha: 1))
        static let properBlack = #colorLiteral(red: 0.149019599, green: 0.149019599, blue: 0.149019599, alpha: 1)
        static let goodDarkTheme = Color(uiColor: #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1))
        static let sunMaxColor = #colorLiteral(red: 0.1332838535, green: 0.6956239343, blue: 0.889532268, alpha: 1)
        static let moonAndStarsColor = #colorLiteral(red: 0.5618619323, green: 0.3260331154, blue: 1, alpha: 1)
        static let cloudSunColor = #colorLiteral(red: 0.3795131445, green: 0.7058345675, blue: 0.8753471971, alpha: 1)
        static let cloudMoonColor = #colorLiteral(red: 0.521438539, green: 0.5413015485, blue: 0.8576574922, alpha: 1)
//        static let cloudy = #colorLiteral(red: 0.4886933565, green: 0.624339819, blue: 0.7615836859, alpha: 1)
        static let cloudy = #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1)

        static let cloudSunRainColor = #colorLiteral(red: 0.1450087726, green: 0.5186601877, blue: 0.8773562908, alpha: 1)
        static let cloudMoonRainColor = #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1)
        static let cloudBoltColor = #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1)
        static let cloudBoltRainColor = #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1)
        static let wind = #colorLiteral(red: 0.3438811302, green: 0.6744567752, blue: 0.9567326903, alpha: 1)
        static let haze = #colorLiteral(red: 0.6361310482, green: 0.6071113944, blue: 0.5944020152, alpha: 1)
        static let cloudSnow = #colorLiteral(red: 0.2117647059, green: 0.3294117647, blue: 0.5254901961, alpha: 1)
        static let precipitationBlue = Color(uiColor: #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1))
        static let cloudyBlue = #colorLiteral(red: 0.518604517, green: 0.6436038613, blue: 0.78536731, alpha: 1)
        static let tenDayBarColor = #colorLiteral(red: 0.0978968963, green: 0.3324657381, blue: 0.4080292583, alpha: 1)
        static let darkRed = #colorLiteral(red: 0.6502581835, green: 0.08077467233, blue: 0.02964879759, alpha: 1)
        static let lightPink = #colorLiteral(red: 1, green: 0.7621075511, blue: 0.7261560559, alpha: 1)
        static let maroon = #colorLiteral(red: 0.4117647059, green: 0.003921568627, blue: 0.01960784314, alpha: 1)
        static let prussianBlue = #colorLiteral(red: 0.003921568627, green: 0.2, blue: 0.3294117647, alpha: 1)
    }
}
