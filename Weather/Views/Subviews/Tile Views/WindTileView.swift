//
//  WindTileView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI

struct WindTileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStateManager: AppStateManager
    
    let windData: WindData
    let hourlyWindData: [WindData]
    let setTodayWeather: Bool
    let backgroundColor: Color
    
    var body: some View {
        let color = appStateManager.blendColorWithTwentyPercentWhite(themeColor: backgroundColor)

        VStack(alignment: .leading) {
            Text("Wind")
                .bold()
                .padding(.bottom)
            
            if setTodayWeather {
                todayData
            } else {
                tomorrowData
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                ScrollViewReader { proxy in
                    HStack {
                        EmptyView()
                            .id(0)
                        ForEach(hourlyWindData) { datum in
                            Image(systemName: "location.fill")
                                .rotationEffect(.degrees(WeatherManager.shared.getRotation(direction: datum.windDirection) + 180))
                                .padding(.vertical)
                                .padding(.horizontal, 10)
                        }
                    }
                    .onChange(of: appStateManager.resetScrollToggle) { _ in
                        proxy.scrollTo(0)
                    }
                    
                    WindBarGraph(hourlyWind: hourlyWindData)
                        .frame(height: 100)
   
                }
            }
        }
        .padding()
        .padding(.top)
        .foregroundStyle(.white)
        .background(color)
//        .brightness(-0.15)
        .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
        .padding()
        
    }
    
    
    
    var todayData: some View {
        HStack(spacing: 30.0) {
            HStack {
                Text(windData.windSpeed)
                    .bold()
                    .font(.system(size: 70))
                    .foregroundColor(windData.windColor)
                
                VStack {
                    Image(systemName: "location.fill")
                        .rotationEffect(.degrees(WeatherManager.shared.getRotation(direction: windData.windDirection) + 180) )
                    Text(windData.speedUnit)
                }
            }
            
            
            
            VStack(alignment: .leading) {
                Text(windData.windDescriptionForMPH)
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("Now · From \(windData.readableWindDirection)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                
            }
        }
    }
    
    var tomorrowData: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text(windData.windDescriptionForMPH)
                .fontWeight(.light)
                .font(.title)
            Text("Average of about \(windData.windSpeed) \(windData.speedUnit)")
                .font(.subheadline)
        }
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            WindTileView(
                windData: WindData.windDataHolder[0],
                hourlyWindData: WindData.windDataHolder,
                setTodayWeather: true,
                backgroundColor: Color(uiColor: K.Colors.haze)
            )
            .environmentObject(AppStateManager())
            
        }
    }
}
