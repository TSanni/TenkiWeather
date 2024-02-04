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
        let color = appStateManager.blendColorWithTwentyPercentWhite(themeColor: color)
        
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
                                    .font(.callout)
                                
                                Image(systemName: imageName)
                                    .renderingMode(.original)
                                    .frame(width: 25, height: 25)
                                    .font(.title3)
                                
                                Text(item.date)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.top)
                            .padding(.horizontal, 10)
                            .frame(width: 60)
                        }
                    }
                    
                    HourlyForecastLineGraphView(hourlyTemperatures: hourlyTemperatures)
                        .frame(height: 50)
                    
                    HStack {
                        ForEach(hourlyTemperatures) { item in
                            HStack(spacing: 2) {
                                TileImageProgressView(
                                    height: 10,
                                    value: convertStringToCGFloat(precipitationString: item.chanceOfPrecipitation),
                                    sfSymbol: "drop.fill",
                                    color: K.Colors.precipitationBlue
                                )
                                Text(item.chanceOfPrecipitation)
                                    .font(.caption2)

                            }
                            .padding([.horizontal, .bottom], 10)
                            .frame(width: 60)

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
            ZStack {
                RoundedRectangle(cornerRadius: K.tileCornerRadius)
                    .stroke(lineWidth: 0.5)
                    .fill(.white)
                RoundedRectangle(cornerRadius: K.tileCornerRadius).fill(color)
            }
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
