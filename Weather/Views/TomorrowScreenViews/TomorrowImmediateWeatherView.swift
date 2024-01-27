//
//  TomorrowImmediateWeatherView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct TomorrowImmediateWeatherView: View {
    let tomorrowWeather: TomorrowWeatherModel
    @EnvironmentObject var appState: AppStateManager

    
    var body: some View {
        let imageSymbol = appState.fillImageToPrepareForRendering(symbol: tomorrowWeather.tomorrowSymbol)
        let blendColor1 = appState.blendColors(themeColor: tomorrowWeather.backgroundColor)
        let blendColor2 = appState.blendColors2(themeColor: tomorrowWeather.backgroundColor)
        
        VStack(alignment: .leading) {
            Text(tomorrowWeather.date)
                .fontWeight(.semibold)
            
            HStack {
                HStack(spacing: 0.0) {
                    Text("\(tomorrowWeather.tomorrowHigh)°")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(blendColor1)


                    Text("/\(tomorrowWeather.tomorrowLow)°")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(blendColor2)
                }
           
                Image(systemName: imageSymbol)
                    .renderingMode(.original)
                    .font(.system(size: 45))
            }
            
            Text(tomorrowWeather.tomorrowWeatherDescription.description)
                .font(.headline)
        }
        .foregroundStyle(blendColor1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()

    }
}

#Preview {
    ZStack {
        TomorrowWeatherModel.tomorrowDataHolder.backgroundColor
        TomorrowImmediateWeatherView(tomorrowWeather: TomorrowWeatherModel.tomorrowDataHolder)
            .environmentObject(AppStateManager())

    }
}
