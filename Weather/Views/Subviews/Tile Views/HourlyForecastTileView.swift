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
    
    
    
    //    func checkForZeroPercentPrecipitation(precipitation: String) -> String {
    //        if precipitation == "0%" {
    //            return ""
    //        } else {
    //            return precipitation
    //        }
    //    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                
                VStack {
                    
                    HStack {
                        EmptyView()
                            .id(0)
                        ForEach(hourlyTemperatures) { item in
                            let imageName = appStateManager.fillImageToPrepareForRendering(symbol: item.symbol)
                            
                            VStack(spacing: 7.0) {
                                Text("\(item.temperature)°")
                                    .fontWeight(.bold)
                                //                        Text(checkForZeroPercentPrecipitation(precipitation: item.chanceOfPrecipitation))
                                //                            .font(.footnote)
                                //                            .foregroundStyle(Color(uiColor: K.Colors.precipitationBlue))
                                
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
                    
                    HourlyForecastLineGraphView(hourlyTemperatures: hourlyTemperatures)
                        .frame(height: 50)
                    
                    HStack(spacing: 0.0) {
                        ForEach(hourlyTemperatures) { i in
                            VStack(spacing: 0.0) {
                                TileImageProgressView(
                                    height: 10,
                                    value: convertStringToCGFloat(precipitationString: i.chanceOfPrecipitation),
                                    sfSymbol: "drop.fill",
                                    color: K.Colors.precipitationBlue
                                )
                                Text(i.chanceOfPrecipitation)
                                    .font(.caption2)
                            }
                        }
                    }
                    .padding(.bottom)
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
        .brightness(-0.15)
        
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
