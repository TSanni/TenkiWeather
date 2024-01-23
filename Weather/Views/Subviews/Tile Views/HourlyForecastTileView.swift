//
//  HourlyForecastTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI



let DUMMY_FORECAST_DATA = [
    HourlyTemperatures.hourlyTempHolderData[0],
    HourlyTemperatures.hourlyTempHolderData[1],
    HourlyTemperatures.hourlyTempHolderData[2],
    HourlyTemperatures.hourlyTempHolderData[3],
    HourlyTemperatures.hourlyTempHolderData[4],
    HourlyTemperatures.hourlyTempHolderData[5],
    HourlyTemperatures.hourlyTempHolderData[6],
    HourlyTemperatures.hourlyTempHolderData[7],


]

struct HourlyForecastTileView: View {
    let hourlyTemperatures: [HourlyTemperatures]
    let color: Color
    
    
    func fillImageToPrepareForRendering(symbol: String) -> String {
        let filledInSymbol = WeatherManager.shared.getImage(imageName: symbol)
        return filledInSymbol
    }
    
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
                    VStack(spacing: 7.0) {
                        Text("\(item.temperature)°")
                            .fontWeight(.bold)
                        Text(checkForZeroPercentPrecipitation(precipitation: item.chanceOfPrecipitation))
                            .font(.footnote)
                            .foregroundStyle(Color(uiColor: K.Colors.precipitationBlue))
                        Image(systemName: fillImageToPrepareForRendering(symbol: item.symbol))
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
    }
}

#Preview {
    ZStack {
        Color(uiColor: K.Colors.cloudMoonRainColor).brightness(0.1)
        HourlyForecastTileView(hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData, color: Color(uiColor: K.Colors.cloudMoonRainColor))
    }
}
