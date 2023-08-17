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
    let hourlyTemperatures: [HourlyTemperatures]
    let graphColor: Color
    

    var body: some View {
        
        Chart(hourlyTemperatures) { item in
            
            //MARK: - Area Graph
            AreaMark(x: .value("Time", item.date), yStart: .value("start", getGraphStartingPoint()), yEnd: .value("temp", Double(item.temperature) ?? 0))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white.opacity(0.2), graphColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            //MARK: - Bar graph
            BarMark(x: .value("Time", item.date), yStart: .value("start", getGraphStartingPoint()), yEnd: .value("temp", Double(item.temperature) ?? 0))
                .foregroundStyle(Color.clear)
                .annotation(position: .top) {
                    Text("\(item.temperature)°")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
        }
        .chartYAxis(.hidden)
        .chartYScale(domain: getGraphStartingPoint()...getGraphEndingPoint())
        .chartXAxis {
            AxisMarks(position: .bottom) { q in
                AxisValueLabel {
                    VStack {

                        Image(systemName: WeatherManager.shared.getImage(imageName: hourlyTemperatures[q.index].symbol))
                            .renderingMode(.original)
                            .font(.title2)
                        
                        Text(hourlyTemperatures[q.index].chanceOfPrecipitation)
                            .font(.footnote)
                            .fontWeight(.light)
                            .foregroundColor(hourlyTemperatures[q.index].chanceOfPrecipitation == "0%" ? .clear : Color(uiColor: K.Colors.precipitationBlue))
                        
                        Text("\(hourlyTemperatures[q.index].date)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .fontWeight(.light)
                            .shadow(color: .white.opacity(0.3), radius: 1, y: 1.7)

                                                                        
                    }
                    .foregroundColor(.black)
                    .font(.subheadline)
                }
            }
        }
    }
    
    
    /// Gets the lowest temperature in the hourlyTemperatures struct array,
    /// then subtracts 10 to get a nice starting point for a graph
    private func getGraphStartingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.min() ?? 0) - 10
    }
    
    /// Returns the highest temperature in the hourlyTemperatures struct array,
    /// then adds 5 to get a nice ending point for a graph
    private func getGraphEndingPoint() -> Double {
        
        var allTemperatures: [Double] = []
        
        for i in 0..<hourlyTemperatures.count {
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.max() ?? 0) + 10
    }
}

//MARK: - Preview
struct WeatherGraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData, HourlyTemperatures.hourlyTempHolderData], graphColor: Color.pink)
//                .environmentObject(WeatherKitManager())
                .frame(height: 200)
//            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: Color.green)
//            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .cyan)
//            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .brown)
//            WeatherGraphView(hourlyTemperatures: [HourlyTemperatures.hourlyTempHolderData], graphColor: .orange)
            //            TodayScreen()
        }
    }
}


