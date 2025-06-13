//
//  Color+extension.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/7/25.
//

import Foundation
import SwiftUI

//TODO: - Start deleleting the old colors

extension Color {
    static let goodLightTheme = Color(uiColor: #colorLiteral(red: 0.9607837796, green: 0.9607847333, blue: 0.9822904468, alpha: 1))
    static let properBlack = Color(uiColor: #colorLiteral(red: 0.149019599, green: 0.149019599, blue: 0.149019599, alpha: 1))
    static let goodDarkTheme = Color(uiColor: #colorLiteral(red: 0.1450980604, green: 0.1450980604, blue: 0.1450980604, alpha: 1))
    static let precipitationBlue = Color(uiColor: #colorLiteral(red: 0.1168219224, green: 0.998493135, blue: 0.9996963143, alpha: 1))
    static let tenDayBarColor = Color(uiColor: #colorLiteral(red: 0.09803921569, green: 0.3333333333, blue: 0.4078431373, alpha: 1))
    static let alertRed = Color(uiColor: #colorLiteral(red: 0.6502581835, green: 0.08077467233, blue: 0.02964879759, alpha: 1))
    static let alertPink = Color(uiColor: #colorLiteral(red: 1, green: 0.7621075511, blue: 0.7261560559, alpha: 1))
    static let alertMaroon = Color(uiColor: #colorLiteral(red: 0.4117647059, green: 0.003921568627, blue: 0.01960784314, alpha: 1))
    static let prussianBlue = Color(uiColor: #colorLiteral(red: 0.003921568627, green: 0.2, blue: 0.3294117647, alpha: 1))
    

    // MARK: Weather condition colors
    static let blowingDustDaylightColor  = Color(uiColor: #colorLiteral(red: 0.5176470588, green: 0.337254902, blue: 0.2352941176, alpha: 1))
    static let blowingDustNightColor = Color(uiColor: #colorLiteral(red: 0.4, green: 0.2392156863, blue: 0.1333333333, alpha: 1))

    static let clearWeatherDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3699404597, blue: 0.5337731242, alpha: 1))
    static let clearWearherNightColor = Color(uiColor: #colorLiteral(red: 0.2117647059, green: 0.3294117647, blue: 0.5254901961, alpha: 1))

    static let cloudyDaylightColor = Color(uiColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
    static let cloudyNightColor = Color(uiColor: #colorLiteral(red: 0.3058823529, green: 0.3176470588, blue: 0.5019607843, alpha: 1))

    static let foggyDaylightColor = Color(uiColor: #colorLiteral(red: 0.4156862745, green: 0.5607843137, blue: 0.831372549, alpha: 1))
    static let foggyNightColor = Color(uiColor: #colorLiteral(red: 0.2901960784, green: 0.3411764706, blue: 0.7294117647, alpha: 1))

    static let hazeDaylightColor = Color(uiColor: #colorLiteral(red: 0.5254901961, green: 0.3333333333, blue: 0.262745098, alpha: 1))
    static let hazeNightColor = Color(uiColor: #colorLiteral(red: 0.4784313725, green: 0.2823529412, blue: 0.2156862745, alpha: 1))

    static let mostlyClearDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3699404597, blue: 0.5337731242, alpha: 1))
    static let mostlyClearNightColor = Color(uiColor: #colorLiteral(red: 0.2117647059, green: 0.3294117647, blue: 0.5254901961, alpha: 1))

    static let mostlyCloudyDaylightColor = Color(uiColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
    static let mostlyCloudyNightColor = Color(uiColor: #colorLiteral(red: 0.2392156863, green: 0.2666666667, blue: 0.4392156863, alpha: 1))

    static let partyCloudyDaylightColor = Color(uiColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
    static let partyCloudyNightColor = Color(uiColor: #colorLiteral(red: 0.3058823529, green: 0.3176470588, blue: 0.5019607843, alpha: 1))

    static let smokyDaylightColor = Color(uiColor: #colorLiteral(red: 0.5254901961, green: 0.3333333333, blue: 0.262745098, alpha: 1))
    static let smokyNightColor = Color(uiColor: #colorLiteral(red: 0.4784313725, green: 0.2823529412, blue: 0.2156862745, alpha: 1))

    static let breezyDaylightColor = Color(uiColor: #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1))
    static let breezyNightColor = Color(uiColor: #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1))

    static let windyDaylightColor = Color(uiColor: #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1))
    static let windyNightColor = Color(uiColor: #colorLiteral(red: 0.3367654085, green: 0.5832664371, blue: 0.7205563188, alpha: 1))

    static let drizzleDaylightColor = Color(uiColor: #colorLiteral(red: 0.1450087726, green: 0.5186601877, blue: 0.8773562908, alpha: 1))
    static let drizzleNightColor = Color(uiColor: #colorLiteral(red: 0.231372549, green: 0.2431372549, blue: 0.4745098039, alpha: 1))

    static let heavyRainDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1))
    static let heavyRainNightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1))

    static let isolatedThunderstormDaylightColor = Color(uiColor: #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1))
    static let isolatedThunderstormNightColor = Color(uiColor: #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1))

    static let rainDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1))
    static let rainNightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3320232332, blue: 0.6122661233, alpha: 1))

    static let sunShowersDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3699404597, blue: 0.5337731242, alpha: 1))
    static let sunShowersNightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.3699404597, blue: 0.5337731242, alpha: 1))

    static let scatteredThunderstormsDaylightColor = Color(uiColor: #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1))
    static let scatteredThunderstormsNightColor = Color(uiColor: #colorLiteral(red: 0.5899515152, green: 0.3875116706, blue: 0.5502174497, alpha: 1))

    static let strongStormsDaylightColor = Color(uiColor: #colorLiteral(red: 0.2352941176, green: 0.2588235294, blue: 0.337254902, alpha: 1))
    static let strongStormsNightColor = Color(uiColor: #colorLiteral(red: 0.2352941176, green: 0.2588235294, blue: 0.337254902, alpha: 1))

    static let thunderstormDaylightColor = Color(uiColor: #colorLiteral(red: 0.2352941176, green: 0.2588235294, blue: 0.337254902, alpha: 1))
    static let thunderstormNightColor = Color(uiColor: #colorLiteral(red: 0.2352941176, green: 0.2588235294, blue: 0.337254902, alpha: 1))

    static let frigidDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let frigidNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let hailDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let hailNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let hotDaylightColor = Color(uiColor: #colorLiteral(red: 0.7176470588, green: 0.4274509804, blue: 0.3960784314, alpha: 1))
    static let hotNightColor = Color(uiColor: #colorLiteral(red: 0.6509803922, green: 0.3725490196, blue: 0.3333333333, alpha: 1))

    static let flurriesDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let flurriesNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let sleetDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let sleetNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let snowDaylightColor = Color(uiColor: #colorLiteral(red: 0.4588235294, green: 0.6862745098, blue: 0.9137254902, alpha: 1))
    static let snowNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let sunFlurriesDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let sunFlurriesNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let wintryMixDaylightColor = Color(uiColor: #colorLiteral(red: 0.3795131445, green: 0.7058345675, blue: 0.8753471971, alpha: 1))
    static let wintryMixNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let blizzardDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let blizzardNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let blowingSnowDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let blowingSnowNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let freezingDrizzleDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let freezingDrizzleNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let freezingRainDaylightColor = Color(uiColor: #colorLiteral(red: 0, green: 0.5921568627, blue: 0.6549019608, alpha: 1))
    static let freezingRainNightColor = Color(uiColor: #colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1))

    static let heavySnowDaylightColor = Color(uiColor: #colorLiteral(red: 0.1411764706, green: 0.168627451, blue: 0.3921568627, alpha: 1))
    static let heavySnowNightColor = Color(uiColor: #colorLiteral(red: 0.1411764706, green: 0.168627451, blue: 0.3921568627, alpha: 1))

    static let hurricaneDaylightColor = Color(uiColor: #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1))
    static let hurricaneNightColor = Color(uiColor: #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1))

    static let tropicalStormDaylightColor = Color(uiColor: #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1))
    static let tropicalStormNightColor = Color(uiColor: #colorLiteral(red: 0.64490062, green: 0.3235638738, blue: 0.5183041692, alpha: 1))
    
    

}
