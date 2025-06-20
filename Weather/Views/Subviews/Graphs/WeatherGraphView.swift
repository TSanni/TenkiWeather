//
//  WeatherGraphView.swift
//  Weather
//
//  Created by Tomas Sanni on 5/30/23.
//

import SwiftUI
import Charts

//MARK: - View
struct WeatherGraphView: View {
    let hourlyTemperatures: [HourlyWeatherModel]
    let graphColor: Color
    let precipitationBlueColor = Color.precipitationBlue

    var body: some View {
        Chart(hourlyTemperatures) { item in
            
            //MARK: - Area Graph
            AreaMark(
                x: .value("time", item.readableDate),
                yStart: .value("start", getGraphStartingPoint()),
                yEnd: .value("temp", Double(item.hourTemperature) ?? 0)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [.white.opacity(0.2), graphColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
             .alignsMarkStylesWithPlotArea()

            //MARK: - Line Graph
            LineMark(
                x: .value("time", item.readableDate),
                y: .value("temp", Double(item.hourTemperature) ?? 0)
            )
            .foregroundStyle(.white.opacity(0.2))
            .symbol(Circle())
            .lineStyle(StrokeStyle(lineWidth: 3))


            //MARK: - Bar graph
            BarMark(
                x: .value("time", item.readableDate),
                yStart: .value("start", getGraphStartingPoint()),
                yEnd: .value("temp", Double(item.hourTemperature) ?? 0)
            )
            .foregroundStyle(Color.clear)
            .annotation(position: .top) {
                Text(item.hourTemperature + "°")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
            }
        }
        .chartPlotStyle(content: { plotArea in
            plotArea.background(Color.clear)
        })
        .chartYAxis(.hidden)
        .chartYScale(domain: getGraphStartingPoint()...getGraphEndingPoint())
        .chartXAxis {
            AxisMarks(position: .bottom) { q in
                AxisValueLabel {
                    VStack(spacing: 0) {
                        /// weather icon
                        Image(systemName: Helper.getImage(imageName: hourlyTemperatures[q.index].symbol))
                            .renderingMode(.original)
                            .font(.title2)
                            .frame(width: 30, height: 30)
                            .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)


                        /// chance of precipitation
                        Text(hourlyTemperatures[q.index].chanceOfPrecipitation)
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(hourlyTemperatures[q.index].chanceOfPrecipitation == "0%" ? .clear : precipitationBlueColor)
                        /// hour
                        Text(hourlyTemperatures[q.index].readableDate)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .fontWeight(.light)
                            .shadow(color: .white.opacity(0.3), radius: 1, y: 1.7)
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }


    /// Gets the lowest temperature in the hourlyTemperatures struct array,
    /// then subtracts 10 to get a nice starting point for a graph
    private func getGraphStartingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].hourTemperature) ?? 0)
        }
        
        return (allTemperatures.min() ?? 0) - 10
    }
    
    /// Returns the highest temperature in the hourlyTemperatures struct array,
    /// then adds 10 to get a nice ending point for a graph
    private func getGraphEndingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].hourTemperature) ?? 0)
        }
        
        return (allTemperatures.max() ?? 0) + 10
    }
}

//MARK: - Preview
#Preview {
    ZStack {
        Color.mint
        ScrollView(.horizontal) {
            WeatherGraphView(hourlyTemperatures: HourlyWeatherModelPlaceholder.hourlyTempHolderDataArray, graphColor: Color.blue)
                .frame(width: UIScreen.main.bounds.width * 2)
                .frame(height: 200)
        }
    }
}


