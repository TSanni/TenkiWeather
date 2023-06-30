//
//  K.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation
import SwiftUI




struct K {
//    static let properBlack = #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1)
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey")

    
    struct Time {
        static let oneHourInSeconds = 3600
        static let twentyFourHoursInSeconds = 86400
        
        static let fifteenHours = 15
        static let twentyFourHours = 24
    }
    
    
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
        static let sunMin = "sun.min"
        static let cloudBoltRain = "cloud.bolt.rain"
        static let cloudDrizzle = "cloud.drizzle"
        static let cloudSnow = "cloud.snow"

        
    }
    struct Colors {
//        static let properBlack = #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1)
//        static let goodDarkTheme = #colorLiteral(red: 0.172824204, green: 0.1956355572, blue: 0.2475694418, alpha: 1)
        static let goodDarkTheme = Color(uiColor: #colorLiteral(red: 0.172824204, green: 0.1956355572, blue: 0.2475694418, alpha: 1))
        static let goodLightTheme = Color(uiColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1))
        static let properBlack = #colorLiteral(red: 0.149019599, green: 0.149019599, blue: 0.149019599, alpha: 1)

        static let clearDay = #colorLiteral(red: 0.1332838535, green: 0.6956239343, blue: 0.889532268, alpha: 1)
        static let dayTimeCloudy = #colorLiteral(red: 0.3795131445, green: 0.7058345675, blue: 0.8753471971, alpha: 1)
        static let haze = #colorLiteral(red: 0.6361310482, green: 0.6071113944, blue: 0.5944020152, alpha: 1)
        static let thunderstorm = #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1)
        static let cloudy = #colorLiteral(red: 0.4886933565, green: 0.624339819, blue: 0.7615836859, alpha: 1)
        static let dayTimeRain = #colorLiteral(red: 0.1450087726, green: 0.5186601877, blue: 0.8773562908, alpha: 1)
        static let nighttimeCloudy = #colorLiteral(red: 0.521438539, green: 0.5413015485, blue: 0.8576574922, alpha: 1)
        static let scatteredThunderstorm = #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1)
        static let nighttimePurple = #colorLiteral(red: 0.5575598478, green: 0.3759173751, blue: 0.9990670085, alpha: 1)
        static let maroon = #colorLiteral(red: 0.5871755481, green: 0.3745910525, blue: 0.5551333427, alpha: 1)
        
        static let precipitationBlue = #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1)
        static let offWhite = #colorLiteral(red: 0.9740188718, green: 0.9712695479, blue: 0.9717465043, alpha: 1)
        
        
        static let moonColor = #colorLiteral(red: 0.7508266568, green: 0.8291798234, blue: 0.8629794717, alpha: 1)
        static let darkBlue = #colorLiteral(red: 0.02143974602, green: 0.003193902783, blue: 0.3691283166, alpha: 1)
        static let cloudyBlue = #colorLiteral(red: 0.518604517, green: 0.6436038613, blue: 0.78536731, alpha: 1)
        static let thunderstormPurple = #colorLiteral(red: 0.869899869, green: 0.2400925457, blue: 0.5949490666, alpha: 1)
        static let tenDayBarColor = #colorLiteral(red: 0.0978968963, green: 0.3324657381, blue: 0.4080292583, alpha: 1)
        
        static let textFieldBlinkingBarColor = #colorLiteral(red: 0.6047868133, green: 0.6487623453, blue: 1, alpha: 1)
        
    }
}
