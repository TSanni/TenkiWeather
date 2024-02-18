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
    let hourlyWeather: [HourlyModel]
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
                        ForEach(hourlyWeather) { datum in
                            Image(systemName: "location.fill")
                                .rotationEffect(.degrees(WeatherManager.shared.getRotation(direction: datum.wind.compassDirection) + 180))
                                .padding(.vertical)
                                .padding(.horizontal, 10)
                        }
                    }
                    .onChange(of: appStateManager.resetViews) { _ in
                        proxy.scrollTo(0)
                    }
                    
                    WindBarGraph(hourlyWeather: hourlyWeather)
                        .frame(height: 100)
                }
            }
        }
        .padding()
        .padding(.top)
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
    
    
    
    var todayData: some View {
        HStack(spacing: 30.0) {
            HStack {
                Text(windData.windSpeed)
                    .bold()
                    .font(.system(size: 70))
                    .foregroundColor(windData.windColor)
                
                VStack {
                    Image(systemName: "location.fill")
                        .rotationEffect(.degrees(WeatherManager.shared.getRotation(direction: windData.compassDirection) + 180) )
                    Text(windData.speedUnit)
                }
            }
            
            
            
            VStack(alignment: .leading) {
                Text(windData.windDescription)
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
            Text(windData.windDescription)
                .fontWeight(.light)
                .font(.title)
            Text("Average of about \(windData.windSpeed) \(windData.speedUnit)")
                .font(.subheadline)
        }
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(uiColor: K.Colors.haze).ignoresSafeArea()
            GeometryReader { geo in
                WindTileView(
                    windData: WindData.windDataHolder[0],
                    hourlyWeather: HourlyModel.hourlyTempHolderData,
                    setTodayWeather: true,
                    backgroundColor: Color(uiColor: K.Colors.haze)
                )
                .environmentObject(AppStateManager())
                
            }
        }
    }
}
