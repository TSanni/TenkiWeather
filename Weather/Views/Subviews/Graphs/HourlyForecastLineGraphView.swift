//
//  HourlyForecastLineGraphView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/31/24.
//

import SwiftUI
import Charts

struct HourlyForecastLineGraphView: View {
    let hourlyTemperatures: [HourlyTemperatures]
    
    var body: some View {

        Chart {
            ForEach(hourlyTemperatures) { item in
                //MARK: - Line Graph
                LineMark(
                    x: .value("time", item.date),
                    y: .value("temp", Double(item.temperature) ?? 0)
                )
                .symbol(.circle)

            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartYScale(domain: getGraphStartingPoint()...getGraphEndingPoint())
        
    }
    
    
    
    /// Gets the lowest temperature in the hourlyTemperatures struct array,
    private func getGraphStartingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.min() ?? 0)
    }
    
    /// Returns the highest temperature in the hourlyTemperatures struct array,
    private func getGraphEndingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.max() ?? 0)
    }
}

#Preview {
    HourlyForecastLineGraphView(hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData)
}
