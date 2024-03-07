//
//  HourlyForecastTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI




struct HourlyForecastTileView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    let hourlyTemperatures: [HourlyWeatherModel]
    let color: Color

    var body: some View {
        let color = appStateViewModel.blendColorWith20PercentWhite(themeColor: color)
        
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        EmptyView()
                            .id(0)
                        ForEach(hourlyTemperatures) { item in
                            let imageName = appStateViewModel.fillImageToPrepareForRendering(symbol: item.symbol)
                            
                            VStack(spacing: 7.0) {
                                Text(item.hourTemperature + "°")
                                    .font(.callout)
                                
                                Image(systemName: imageName)
                                    .renderingMode(.original)
                                    .frame(width: 25, height: 25)
                                    .font(.title3)
                                
                                Text(item.readableDate)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.top)
                            .padding(.horizontal, 10)
                            .frame(width: 63)
                        }
                    }
                    
                    HourlyForecastLineGraphView(hourlyTemperatures: hourlyTemperatures)
                        .frame(height: 50)
                    
                    HStack {
                        ForEach(hourlyTemperatures) { item in
                            HStack(spacing: 2) {
                                TileImageProgressView(
                                    height: 10,
                                    value: item.precipitationChance * 100,
                                    sfSymbol: "drop.fill",
                                    color: K.ColorsConstants.precipitationBlue
                                )
                                Text(item.chanceOfPrecipitation)
                                    .font(.caption2)

                            }
                            .padding([.horizontal, .bottom], 10)
                            .frame(width: 63)

                        }
                    }
                    
                }
                .onChange(of: appStateViewModel.resetViews) { _ in
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




#Preview {
    ZStack {
        Color(uiColor: K.ColorsConstants.haze).brightness(0.1)
        HourlyForecastTileView(
            hourlyTemperatures: HourlyWeatherModel.hourlyTempHolderData,
            color: Color(uiColor: K.ColorsConstants.haze)
        )
        .environmentObject(AppStateViewModel.shared)
    }
}
