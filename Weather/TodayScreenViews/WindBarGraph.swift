//
//  WindBarGraph.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI
import Charts

struct WindBarGraph: View {
    
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
//            Image(systemName: "location.fill").rotationEffect(.degrees(getDirectionRotation(direction: "east") ?? 0))
//            
            
            ZStack {
                
                //MARK: - Background Bar Graph to place location images equally in height
                Chart(mockTestData) { item in
                    BarMark(x: .value("time", item.xAxis), y: .value("windSpeed", getLargestValue()))
                        .foregroundStyle(Color.clear)
                        .annotation(position: .top) {
                            Image(systemName: "location.fill").rotationEffect(.degrees(getDirectionRotation(direction: "east") ?? 0))
                                .foregroundColor(.secondary)
                                .offset(y: -20)
                        }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { q in
                        AxisValueLabel {
                            Text("\(mockTestData[q.index].xAxis)")

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
                
                Chart(mockTestData) { item in
                    BarMark(x: .value("time", item.xAxis), y: .value("windSpeed", item.yAxis))
                        .annotation(position: .top) {
                            Text("\(item.yAxis.formatted())")
                        }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { q in
                        AxisValueLabel {
                            Text("\(mockTestData[q.index].xAxis)")
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
    
    
    func getLargestValue() -> Double {
        
        var highest: Double = 0
        
        for i in 0..<mockTestData.count {
            if mockTestData[i].yAxis > highest {
                highest = mockTestData[i].yAxis
            }
        }
        
        return highest
    }
    
    
    func getDirectionRotation(direction: String) -> Double? {
        switch direction {
            case "north":
                return -45
            case "north west":
                return -90
            case "north east":
                return 0
            case "west":
                return -135
            case "south":
                return -225
            case "south west":
                return -180
            case "south east":
                return -270
            case "east":
                return 45

                
            default:
                return nil
        }
        
        
    }
    
}

struct WindBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        WindBarGraph()
            .frame(height: 300)
    }
}
