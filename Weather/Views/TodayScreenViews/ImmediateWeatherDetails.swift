//
//  ImmediateWeatherDetails.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI

struct ImmediateWeatherDetails: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    
    let currentWeather: TodayWeatherModel

    
    var body: some View {
        let imageSymbol = appStateViewModel.fillImageToPrepareForRendering(symbol: currentWeather.symbolName)
        let blendColor1 = appStateViewModel.mixColorWith70PercentWhite(themeColor: currentWeather.backgroundColor)
        let blendColor2 = appStateViewModel.mixColorWith60PercentWhite(themeColor: currentWeather.backgroundColor)

        
        
        VStack(alignment: .leading) {
            
            Text("Now")
                .fontWeight(.semibold)
            
            HStack {
                HStack {
                    Text(currentWeather.currentTemperature + "°")
                        .font(.system(size: 85, weight: .bold, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    
                    Image(systemName: imageSymbol)
                        .renderingMode(.original)
                        .font(.system(size: 45))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(currentWeather.weatherDescription.description)
                        .fontWeight(.semibold)
                        .font(.title3)
                    Text("Feels like \(currentWeather.feelsLikeTemperature)°")
                        .foregroundStyle(blendColor2)
                        .fontWeight(.semibold)
                        .font(.headline)
                }
            }
            
            Text("High: \(currentWeather.todayHigh)° • Low: \(currentWeather.todayLow)°")
                .foregroundStyle(blendColor2)
        }
        .foregroundStyle(blendColor1)
        .padding()
        
    }
}

#Preview {
    ZStack {
        TodayWeatherModelPlaceHolder.holderData.backgroundColor
        ImmediateWeatherDetails(currentWeather: TodayWeatherModelPlaceHolder.holderData)
            .environmentObject(AppStateViewModel.shared)
    }
}




