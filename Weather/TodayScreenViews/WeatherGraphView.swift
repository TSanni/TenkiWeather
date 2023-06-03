//
//  WeatherGraphView.swift
//  Weather
//
//  Created by Tomas Sanni on 5/30/23.
//

import SwiftUI
import Charts




struct TestGraphStruct: Identifiable {
    var id = UUID()
    let xAxis: String
    let yAxis: Double
    
    
    
}

struct WeatherGraphView: View {
    
    let min: Double = 65
    let graphColor: Color
    let gradient = LinearGradient(colors: [.white.opacity(0.2), Color(red: 0.558, green: 0.376, blue: 0.999)], startPoint: .top, endPoint: .bottom)
    
    let mockTestData: [TestGraphStruct] = [TestGraphStruct(xAxis: "7 AM", yAxis: 69),
                                           TestGraphStruct(xAxis: "8 AM", yAxis: 77),
                                           TestGraphStruct(xAxis: "9 AM", yAxis: 75),
                                           TestGraphStruct(xAxis: "10 AM", yAxis: 73),
                                           TestGraphStruct(xAxis: "11 AM", yAxis: 72),
                                           TestGraphStruct(xAxis: "12 PM", yAxis: 71),
                                           TestGraphStruct(xAxis: "1 PM", yAxis: 70),
                                           TestGraphStruct(xAxis: "2 PM", yAxis: 69)
                                           
    ]
    var body: some View {
        
        Chart(mockTestData) { item in
            
            //MARK: - Area Graph
            AreaMark(x: .value("A", item.xAxis), yStart: .value("b", min), yEnd: .value("c", item.yAxis))
                .foregroundStyle(gradient)
            
            //MARK: - Bar graph
            BarMark(x: .value("A", item.xAxis), yStart: .value("b", min), yEnd: .value("c", item.yAxis))
                .foregroundStyle(Color.clear)
                .annotation(position: .top) {
                    Text("\(item.yAxis.formatted())°")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
        }
        .chartYScale(domain: 65...80)
        .chartXAxis {
            AxisMarks(position: .bottom) { q in
                AxisValueLabel {
                    VStack {
                        Text("\(mockTestData[q.index].xAxis)")
                            .font(.footnote)
                            .fontWeight(.light)
                        Image(systemName: "cloud")
                    }
                    .foregroundColor(.black)
                    .font(.subheadline)
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

struct WeatherGraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeatherGraphView(graphColor: Color.pink)
                .frame(height: 200)
            WeatherGraphView(graphColor: Color.green)
            WeatherGraphView(graphColor: .cyan)
            WeatherGraphView(graphColor: .brown)
            WeatherGraphView(graphColor: .orange)
            //            TodayScreen()
        }
    }
}






/*
 
 //MARK: - Bar graph
 BarMark(
 x: .value("Category", item.xAxis),
 y: .value("Value", item.yAxis)
 )
 .foregroundStyle(Color.clear.gradient)
 .annotation(position: .top) {
 Text("\(item.yAxis.formatted())")
 }
 
 //MARK: - Line Graph
 LineMark(
 x: .value("Category", item.xAxis),
 y: .value("Value", item.yAxis)
 )
 .foregroundStyle(Color.purple.gradient)
 
 //MARK: - Area Graph
 AreaMark(
 x: .value("Category", item.xAxis),
 y: .value("Value", item.yAxis)
 )
 .foregroundStyle(Color.blue.gradient)
 
 
 
 
 */
