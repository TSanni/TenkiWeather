//
//  ImmediateWeatherDetails.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI

struct ImmediateWeatherDetails: View {
    
    
    let currentWeather: TodayWeatherModel
    
    
    func blendColors(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.7, color2: themeColor, intensity2: 0.3))
        
        return blendedColor
    }
    
    func blendColors2(themeColor: Color) -> Color {
        let themeColor = UIColor(themeColor)
        let blendedColor = Color(UIColor.blend(color1: .white, intensity1: 0.6, color2: themeColor, intensity2: 0.4))
        
        return blendedColor
    }
    
    func fillImageToPrepareForRendering(symbol: String) -> String {
        let filledInSymbol = WeatherManager.shared.getImage(imageName: symbol)
        return filledInSymbol
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Now")
                .fontWeight(.semibold)
                .foregroundStyle(blendColors(themeColor: currentWeather.backgroundColor))
            
            HStack {
                HStack {
                    Text("\(currentWeather.currentTemperature)°")
                        .font(.system(size: 75, weight: .bold, design: .default))
                        .foregroundColor(blendColors(themeColor: currentWeather.backgroundColor))

                    
                    Image(systemName: fillImageToPrepareForRendering(symbol: currentWeather.symbol))
                        .renderingMode(.original)
                        .font(.largeTitle)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(currentWeather.weatherDescription.description)
                        .foregroundStyle(blendColors(themeColor: currentWeather.backgroundColor))
                        .fontWeight(.semibold)
                    Text("Feels like \(currentWeather.feelsLikeTemperature)°")
                        .foregroundStyle(blendColors2(themeColor: currentWeather.backgroundColor))
                        .fontWeight(.semibold)
//                        .brightness(-0.3)

                }
            }
            
            Text("High: \(currentWeather.todayHigh)° • Low: \(currentWeather.todayLow)°")
                .foregroundStyle(blendColors2(themeColor: currentWeather.backgroundColor))
        }
        .padding()
        
    }
}

#Preview {
    ZStack {
        TodayWeatherModel.holderData.backgroundColor
        ImmediateWeatherDetails(currentWeather: TodayWeatherModel.holderData)
    }
}



extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
