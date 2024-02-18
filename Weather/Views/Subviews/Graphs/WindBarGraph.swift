//
//  WindBarGraph.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI
import Charts
import WeatherKit


//MARK: - Preview
struct WindBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        WindBarGraph(hourlyWeather: HourlyModel.hourlyTempHolderData)
            .background(Color.indigo)
            .frame(height: 500)
    }
}


//MARK: - View
struct WindBarGraph: View {
    let hourlyWeather: [HourlyModel]
    
    var body: some View {
        //MARK: - Bar Graph with wind data
        Chart(hourlyWeather) { item in
            BarMark(
                x: .value("time", item.readableDate),
                y: .value("windSpeed", Double(item.wind.windSpeed) ?? 0)
            )
            .foregroundStyle(item.wind.windColor)
            .annotation(position: .top) {
                Text(item.wind.windSpeed) // TODO: Not updating
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
    
    
    /// This function accesses the hourlyWeather array and returns the largest wind speed value
    func getLargestValue() -> Double {
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


