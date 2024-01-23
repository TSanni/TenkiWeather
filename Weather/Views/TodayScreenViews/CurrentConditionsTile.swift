//
//  CurrentConditionsTile.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI

struct CurrentConditionsTile: View {
    
//    @EnvironmentObject var weather: WeatherViewModel
//    let currentWeather: TodayWeatherModel
    let title: String
    let width: CGFloat
    let value: String
    let subValue: String
    let backgroundColor: Color
    
    
    
    func removePercent(humidity: String?) -> Double {
        let original = humidity ?? ""
        let ggb = original.dropLast()
        
        let covertHumidStringToNumber = Double(ggb) ?? 0
        return covertHumidStringToNumber / 100
    }

    
    var body: some View {
        
                VStack(alignment: .leading) {
                    Text(title)
                        .padding(.bottom)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(value)
                                .font(.title)
                            Text(subValue)
                        }
                        
                        Spacer()
                        
//                        Image(systemName: "location.fill")
//                            .font(.largeTitle)
//                            .foregroundStyle(Color(uiColor: UIColor(red: 0.80, green: 0.94, blue: 0.97, alpha: 1.00)))
//                            .rotationEffect(.degrees(WeatherManager.shared.getRotation(direction: .southwest) + 180))
                        
//                        CustomProgressView(progress: removePercent(humidity: weather.currentWeather.currentDetails.humidity))
//                            .frame(height: 20)
                    }
                    
                }
                .foregroundStyle(.white)
                .padding()
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: width)

            
        
    }
}

#Preview {
    CurrentConditionsTile(title: "Humidity", width: 200, value: "95%", subValue: "Dew point 63°", backgroundColor: Color(uiColor: K.Colors.cloudMoonRainColor))
        .brightness(-0.15)
        .environmentObject(WeatherViewModel())
}
