//
//  TomorrowImmediateWeatherView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct TomorrowImmediateWeatherView: View {
    let tomorrowWeather: DailyWeatherModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    
    var body: some View {
        let imageSymbol = appStateViewModel.fillImageToPrepareForRendering(symbol: tomorrowWeather.symbolName)
        let blendColor1 = appStateViewModel.mixColorWith70PercentWhite(themeColor: tomorrowWeather.backgroundColor)
        let blendColor2 = appStateViewModel.mixColorWith60PercentWhite(themeColor: tomorrowWeather.backgroundColor)
        
        VStack(alignment: .leading) {
            Text(tomorrowWeather.readableDate + " - Tomorrow")
                .fontWeight(.semibold)
            
            HStack {
                HStack(spacing: 0.0) {
                    Text("\(tomorrowWeather.dayHigh)°")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(blendColor1)


                    Text("/\(tomorrowWeather.dayLow)°")
                        .font(.system(size: 50, weight: .bold, design: .default))
                        .foregroundStyle(blendColor2)
                }
           
                Image(systemName: imageSymbol)
                    .renderingMode(.original)
                    .font(.system(size: 45))
            }
            
            Text(tomorrowWeather.dayWeatherDescription.description)
                .font(.headline)
        }
        .foregroundStyle(blendColor1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()

    }
}

#Preview {
    ZStack {
        DailyWeatherModel.placeholder.backgroundColor
        TomorrowImmediateWeatherView(tomorrowWeather: DailyWeatherModel.placeholder)
            .environmentObject(AppStateViewModel.shared)

    }
}
