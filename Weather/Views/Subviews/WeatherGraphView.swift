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
    @EnvironmentObject var vm: WeatherKitManager
    let hourlyTemperatures: [HourlyTemperatures]
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
        
        Chart(hourlyTemperatures) { item in
            
            //MARK: - Area Graph
            AreaMark(x: .value("A", item.date), yStart: .value("b", getGraphStartingPoint()), yEnd: .value("c", Double(item.temperature) ?? 0))
                .foregroundStyle(LinearGradient(colors: [.white.opacity(0.2), graphColor], startPoint: .top, endPoint: .bottom))
            
            //MARK: - Bar graph
            BarMark(x: .value("A", item.date), yStart: .value("b", getGraphStartingPoint()), yEnd: .value("c", Double(item.temperature) ?? 0))
                .foregroundStyle(Color.clear)
                .annotation(position: .top) {
                    Text("\(item.temperature)°")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
        }
        .chartYScale(domain: getGraphStartingPoint()...getGraphEndingPoint())
        .chartXAxis {
            AxisMarks(position: .bottom) { q in
                AxisValueLabel {
                    VStack {
                        let symbolColors = vm.getSFColorForIcon(sfIcon: hourlyTemperatures[q.index].icon)

                        Text("\(hourlyTemperatures[q.index].date)")
                            .font(.footnote)
                            .fontWeight(.light)
                        
                        Text(hourlyTemperatures[q.index].chanceOfPrecipitation)
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(hourlyTemperatures[q.index].chanceOfPrecipitation == "0%" ? .clear : K.Colors.precipitationBlue)
                        
                        if hourlyTemperatures[q.index].icon == "cloud" {
                            Image(systemName: "\(hourlyTemperatures[q.index].icon).fill")
                                .foregroundColor(.white)
                        } else if hourlyTemperatures[q.index].icon == "sun.max" {
                            Image(systemName: "\(hourlyTemperatures[q.index].icon).fill")
                                .foregroundColor(.yellow)
                        }
                        else {
                            Image(systemName: "\(hourlyTemperatures[q.index].icon).fill")
                                .foregroundStyle(symbolColors[0], symbolColors[1], symbolColors[2])
                        }
                        

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
    
    
    func getGraphStartingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.min() ?? 0) - 10
    }
    
    func getGraphEndingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.max() ?? 0) + 10
    }
}

struct WeatherGraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: Color.pink)
                .frame(height: 200)
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: Color.green)
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .cyan)
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .brown)
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .orange)
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
