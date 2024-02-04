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

    var body: some View {
        let color = appStateManager.blendColorWithTwentyPercentBlack(themeColor: color)
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        EmptyView()
                            .id(0)
                        ForEach(hourlyTemperatures) { item in
                            let imageName = appStateManager.fillImageToPrepareForRendering(symbol: item.symbol)
                            
                            VStack(spacing: 7.0) {
                                Text("\(item.temperature)°")
                                    .fontWeight(.bold)
                                
                                Image(systemName: imageName)
                                    .renderingMode(.original)
                                    .frame(width: 25, height: 25)
                                    .font(.title3)
                                Text(item.date)
                                    .fontWeight(.medium)
                            }
                            .padding(.top)
                            .padding(.horizontal, 10)
                        }
                    }
                    
                    HourlyForecastLineGraphView(hourlyTemperatures: hourlyTemperatures)
                        .frame(height: 50)
                    
                    HStack {
                        ForEach(hourlyTemperatures) { item in
                            VStack(spacing: 0.0) {
                                TileImageProgressView(
                                    height: 10,
                                    value: convertStringToCGFloat(precipitationString: item.chanceOfPrecipitation),
                                    sfSymbol: "drop.fill",
                                    color: K.Colors.precipitationBlue
                                )
                                Text(item.chanceOfPrecipitation)
                                    .font(.caption2)
                                
                                Text(item.date)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.clear)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    
                }
                .onChange(of: appStateManager.resetScrollToggle) { _ in
                    proxy.scrollTo(0)
                }
            }
            
            
        }
        .foregroundStyle(.white)
        .background {
            RoundedRectangle(cornerRadius: K.tileCornerRadius).fill(color)
        }
        .padding()
        
    }
}


func convertStringToCGFloat(precipitationString: String) -> CGFloat {
    let removePercent = precipitationString.dropLast()
    if let converted = Double(removePercent) {
        return converted
    } else {
        return 50
    }
    
}

#Preview {
    ZStack {
        Color(uiColor: K.Colors.haze).brightness(0.1)
        HourlyForecastTileView(
            hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData,
            color: Color(uiColor: K.Colors.haze)
        )
        .environmentObject(AppStateManager())
    }
}
