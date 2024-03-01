//
//  WindTileView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI
import Charts

struct WindTileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStateManager: AppStateManager
    
    let windData: WindData
    let hourlyWeather: [HourlyWeatherModel]
    let setTodayWeather: Bool
    let backgroundColor: Color
    let weatherViewModel = WeatherViewModel.shared
    
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
                        ForEach(hourlyWeather) { hour in
                            VStack {
                                Image(systemName: "location.fill")
                                    .rotationEffect(.degrees(weatherViewModel.getRotation(direction: hour.wind.compassDirection) + 180))
                                    .padding(.vertical)
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .onChange(of: appStateManager.resetViews) { _ in
                        proxy.scrollTo(0)
                    }
                    
                    //MARK: - Bar Graph with wind data
                    Chart(hourlyWeather) { hour in
                        BarMark(
                            x: .value("time", hour.readableDate),
                            y: .value("windSpeed", hour.windTruth.windSpeedNumber)
                        )
                        .foregroundStyle(hour.wind.windColor)
                        .annotation(position: .top) {
                            Text(hour.wind.windSpeed)
                                .foregroundStyle(.white)
                        }
                    }
                    .chartYScale(domain: 0...(getLargestValue()))
                    .chartYAxis(.hidden)
                    .chartXAxis {
                        AxisMarks(position: .bottom) { q in
                            AxisValueLabel {
                                Text(hourlyWeather[q.index].readableDate)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
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
                        .rotationEffect(.degrees(weatherViewModel.getRotation(direction: windData.compassDirection) + 180) )
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
    
    /// This function accesses the hourlyWeather array and returns the largest wind speed value
    private func getLargestValue() -> Double {
        var highest: Double = 0
        
        for i in 0..<hourlyWeather.count {
            if let windSpeed = Double(hourlyWeather[i].wind.windSpeed) {
                if windSpeed > highest {
                    highest = windSpeed
                }
            }
        }
        
        return highest
    }
}

// MARK: - Preview
struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(uiColor: K.ColorsConstants.haze).ignoresSafeArea()
            GeometryReader { geo in
                WindTileView(
                    windData: WindData.windDataHolder[0],
                    hourlyWeather: HourlyWeatherModel.hourlyTempHolderData,
                    setTodayWeather: true,
                    backgroundColor: Color(uiColor: K.ColorsConstants.haze)
                )
                .environmentObject(AppStateManager.shared)
                
            }
        }
    }
}
