//
//  WindBarGraph.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI
import Charts
import WeatherKit

struct WindBarGraph: View {
    let hourlyWind: [WindData]
    
    var body: some View {
        ZStack {
            
            //MARK: - Background Bar Graph to place location images equally in height
            Chart(hourlyWind) { item in
                BarMark(x: .value("time", item.time ?? "-"), y: .value("windSpeed", getLargestValue() + 10))
                    .foregroundStyle(Color.clear)
                    .annotation(position: .top) {
                        if item.windSpeed != "0" {
                            Image(systemName: "location.fill")
                                .rotationEffect(.degrees(getRotation(direction: item.windDirection) + 180))
                                .foregroundColor(.secondary)
                        }
                    }
            }
            .chartYScale(domain: 0...(getLargestValue() + 20))
//            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(position: .bottom) { q in
                    AxisValueLabel {
                        Text("\(hourlyWind[q.index].time ?? "-")")
                    }
                }
            }
            
            //MARK: - Bar Graph with wind data
            Chart(hourlyWind) { item in
                BarMark(x: .value("time", item.time ?? "-"), y: .value("windSpeed", Double(item.windSpeed) ?? 0))
                    .foregroundStyle(item.windColor)
                    .annotation(position: .top) {
                        Text("\(item.windSpeed)")
                    }
            }
            .chartYScale(domain: 0...(getLargestValue() + 20))
//            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks(position: .bottom) { q in
                    AxisValueLabel {
                        Text("\(hourlyWind[q.index].time ?? "-")")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        
    }
    
    
    /// This function accesses the hourlyWind array and returns the largest wind speed value
    func getLargestValue() -> Double {
        var highest: Double = 0
        
        for i in 0..<hourlyWind.count {
            if let windSpeed = Double(hourlyWind[i].windSpeed) {
                if windSpeed > highest {
                    highest = windSpeed
                }
            }
        }
        
        return highest
        
        // Optionally can also use max() method to get largest number
    }
    
    
    
    func getRotation(direction: Wind.CompassDirection) -> Double {
        // starting pointing east. Subtract 90 to point north
        // Think of this as 0 on a pie chart
        let zero: Double = 45
        
        switch direction {
            case .north:
                return zero - 90
            case .northNortheast:
                return zero - 67.5
            case .northeast:
                return zero - 45
            case .eastNortheast:
                return zero - 22.5
            case .east:
                return zero
            case .eastSoutheast:
                return zero + 22.5
            case .southeast:
                return zero + 45
            case .southSoutheast:
                return zero + 67.5
            case .south:
                return zero + 90
            case .southSouthwest:
                return zero + 112.5
            case .southwest:
                return zero + 135
            case .westSouthwest:
                return zero + 157.5
            case .west:
                return zero - 180
            case .westNorthwest:
                return zero - 157.5
            case .northwest:
                return zero - 135
            case .northNorthwest:
                return zero - 112.5
        }
    }
    
}

struct WindBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        WindBarGraph(hourlyWind: [WindData.windDataHolder, WindData.windDataHolder, WindData.windDataHolder])
            .previewDevice("iPhone 12 Pro Max")
            .frame(height: 300)
    }
}
