//
//  K.swift
//  Weather
//
//  Created by Tomas Sanni on 6/10/23.
//

import Foundation


enum K {
    static let googleApiKey = Bundle.main.object(forInfoDictionaryKey: "googlePlacesApiKey") as! String
    static let privacyPolicyURL: String = "https://www.termsfeed.com/live/a13a54bd-d22e-4076-9260-29d2f89d4621"
    static let tileCornerRadius: CGFloat = 20
    static let legalAttributionURL: String = "https://weatherkit.apple.com/legal-attribution.html"
    static let defaultTimezoneIdentifier: String = "America/Chicago"
    static let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    struct MockData {
        static let names = ["Los Angeles, CA, United States", "New York, NY, United States", "Seoul, South Korea", "Gyeongsangnam-do, South Korea", "Tokyo, Japan", "Koka, Shiga, Japan", "Dayuan District , TAO, Taiwan", "Zürich, Switzerland", "Nagoya, Japan", "Miami, United States", "Cairo, Egypt", "Washington, DC, United States", "Svalbard, Norway", "Sapporo, Japan", "Oregon, United States", "Madrid, Spain", "Sugar Land, TX, United States", "São Paulo - SP, Brazil"]
        
        static let latitudes = [33.9697897, 40.753685399999995, 37.550263, 35.3763461, 35.6764225, 34.914825439453125, 25.076522827148438, 47.3768866, 35.18145060000001, 25.7616798, 30.0444196, 38.912068, 77.8749725, 43.0617713, 44.9412527, 40.4192127, 29.595067, -23.5796404]

        static let longitude = [-118.2468148, -73.9991637, 126.9970831, 128.147727, 139.650027, 136.18474154224646, 121.23416710004986, 8.541694, 136.9065571, -80.1917902, 31.2357116, -77.0190228, 20.9751822, 141.3544506, -123.0290197, -3.692517, -95.620962, -46.6550645]
    }

    struct UserDefaultKeys {
        static let unitTemperatureKey: String = "UnitTemperature"
        static let unitDistanceKey: String = "UnitDistance"
        static let unitPrecipitationKey: String = "UnitPrecipitation"
        static let timePreferenceKey: String = "24HourTime"
        static let showTemperatureUnitKey: String = "showTemperatureUnitKey"
        static let migrationFlagKey: String = "hasMigratedTimezones"

    }
    
    struct UserDefaultValue {
        static let fahrenheit: String = "Fahrenheit"
        static let celsius: String = "Celsius"
        static let kelvin: String = "Kelvin"
        static let mph: String = "miles"
        static let kiloPerHour: String = "kilometer"
        static let meterPerSecond: String = "meters"
        static let inches: String = "inches"
        static let millimeters: String = "millimeters"
        static let centimeters: String = "centimeters"
    }
    
    struct TimeConstants {
        static let oneHourInSeconds = 3600.0
        static let sevenHoursInSeconds = 25000.0
        static let twentyFourHoursInSeconds = 86400.0
        static let tenMinutesInSeconds = 60 * 10
        static let fifteenHours: Int = 15
        static let twentyFourHours: Int = 24
        static let hourOnly = "h a" // Ex) 7 AM
        static let hourOnlyMilitary = "HH" // Ex) 13
        static let monthDayHourMinute = "MMM dd, h:mm a" // Ex: Jul 7, 10:08 PM
        static let monthDayHourMinuteMilitary = "dd MMM, HH:mm" // Ex: Jul 7, 13:08
        static let dayOfWeekAndDate = "EEEE, MMM d" // Ex: Tuesday, July 7
        static let hourAndMinute = "h:mm a" // Ex: 12:07 PM
        static let hourAndMinuteMilitary = "HH:mm" // Ex: 12:07 
    }
}
