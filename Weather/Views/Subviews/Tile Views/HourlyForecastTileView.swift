//
//  HourlyForecastTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI




struct HourlyForecastTileView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    let hourlyTemperatures: [HourlyTemperatures]
    let color: Color
    
    

    func checkForZeroPercentPrecipitation(precipitation: String) -> String {
        if precipitation == "0%" {
            return ""
        } else {
            return precipitation
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyTemperatures) { item in
                    let imageName = appStateManager.fillImageToPrepareForRendering(symbol: item.symbol)
                    
                    VStack(spacing: 7.0) {
                        Text("\(item.temperature)°")
                            .fontWeight(.bold)
                        Text(checkForZeroPercentPrecipitation(precipitation: item.chanceOfPrecipitation))
                            .font(.footnote)
                            .foregroundStyle(Color(uiColor: K.Colors.precipitationBlue))
                        
                        Image(systemName: imageName)
                            .renderingMode(.original)
                            .frame(width: 25, height: 25)
                            .font(.title3)
                        Text(item.date)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 10)
                }
            }
        }
        .foregroundStyle(.white)
        .background {
            RoundedRectangle(cornerRadius: 10).fill(color)
        }
        .padding()
        .brightness(-0.15)

    }
}

#Preview {
    ZStack {
        Color(uiColor: K.Colors.cloudMoonRainColor).brightness(0.1)
        HourlyForecastTileView(hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData, color: Color(uiColor: K.Colors.cloudMoonRainColor))
            .environmentObject(AppStateManager())
    }
}
