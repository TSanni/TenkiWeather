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
    let mockTestData: [TestGraphStruct] = [TestGraphStruct(xAxis: "7 AM", yAxis: 2),
                                           TestGraphStruct(xAxis: "8 AM", yAxis: 1),
                                           TestGraphStruct(xAxis: "9 AM", yAxis: 1),
                                           TestGraphStruct(xAxis: "10 AM", yAxis: 7),
                                           TestGraphStruct(xAxis: "11 AM", yAxis: 1),
                                           TestGraphStruct(xAxis: "12 PM", yAxis: 2),
                                           TestGraphStruct(xAxis: "1 PM", yAxis: 4),
                                           TestGraphStruct(xAxis: "2 PM", yAxis: 5)]
    
    var body: some View {
        VStack {
            
//            Text("\(getLargestValue())")
//            
//
            ZStack {
                
                //MARK: - Background Bar Graph to place location images equally in height
                Chart(hourlyWind) { item in
                    
//                    BarMark(x: .value("time", item.time ?? "-"), yStart: 0, yEnd: 1)
//                        .foregroundStyle(Color.red)
//                        .annotation(position: .top) {
//                            Image(systemName: "location.fill")
//                                .rotationEffect(.degrees(getRotation(direction: item.windDirection) + 180))
//                                .foregroundColor(.secondary)
////                                .offset(y: -20)
//                        }
                    
                    BarMark(x: .value("time", item.time ?? "-"), y: .value("windSpeed", getLargestValue()))
                        .foregroundStyle(Color.red)
                        .annotation(position: .top) {
                            Image(systemName: "location.fill")
                                .rotationEffect(.degrees(getRotation(direction: item.windDirection) + 180))
                                .foregroundColor(.secondary)
                                .offset(y: -20)
                        }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { q in
                        AxisValueLabel {
                            Text("\(hourlyWind[q.index].time ?? "-")")

                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) {
        //                AxisValueLabel()
        //                    .foregroundStyle(.black)
        //                AxisGridLine()
        //                    .foregroundStyle(.secondary)
                    }
                    
                }
                //MARK: - Bar Graph with wind data
                
                Chart(hourlyWind) { item in
                    BarMark(x: .value("time", item.time ?? "-"), y: .value("windSpeed", Double(item.windSpeed) ?? 0))
                        .annotation(position: .top) {
                            Text("\(item.windSpeed)")
                        }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { q in
                        AxisValueLabel {
                            Text("\(hourlyWind[q.index].time ?? "-")")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) {
        //                AxisValueLabel()
        //                    .foregroundStyle(.black)
        //                AxisGridLine()
        //                    .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    
//    func getLargestValue() -> Double {
//
//        var highest: Double = 0
//
//        for i in 0..<mockTestData.count {
//            if mockTestData[i].yAxis > highest {
//                highest = mockTestData[i].yAxis
//            }
//        }
//
//        return highest
//    }
    
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
        WindBarGraph(hourlyWind: [WindData.windDataHolder])
            .frame(height: 300)
    }
}
