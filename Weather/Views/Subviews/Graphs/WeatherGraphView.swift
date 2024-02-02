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
    let precipitationBlueColor = K.Colors.precipitationBlue

    var body: some View {

        Chart(hourlyTemperatures) { item in
            
            //MARK: - Area Graph
            AreaMark(
                x: .value("time", item.date),
                yStart: .value("start", getGraphStartingPoint()),
                yEnd: .value("temp", Double(item.temperature) ?? 0)
            )
            // .interpolationMethod(.cardinal)
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
                x: .value("time", item.date),
                y: .value("temp", Double(item.temperature) ?? 0)
            )
            .foregroundStyle(.white.opacity(0.2))
            .symbol(Circle())
//            .annotation(position: .top) {
//                Text("\(item.temperature)°")
//                    .font(.footnote)
//                    .foregroundColor(.white)
//            }
            .lineStyle(StrokeStyle(lineWidth: 3))


            //MARK: - Bar graph
            BarMark(
                x: .value("time", item.date),
                yStart: .value("start", getGraphStartingPoint()),
                yEnd: .value("temp", Double(item.temperature) ?? 0)
            )
            .foregroundStyle(Color.clear)
            .annotation(position: .top) {
                Text("\(item.temperature)°")
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
                        Image(systemName: WeatherManager.shared.getImage(imageName: hourlyTemperatures[q.index].symbol))
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
                        Text("\(hourlyTemperatures[q.index].date)")
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
            allTemperatures.append(Double(hourlyTemperatures[i].temperature) ?? 0)
        }
        
        return (allTemperatures.min() ?? 0) - 10
    }
    
    /// Returns the highest temperature in the hourlyTemperatures struct array,
    /// then adds 10 to get a nice ending point for a graph
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
        
        ZStack {
            Color.mint
            ScrollView(.horizontal) {
                
                WeatherGraphView(hourlyTemperatures: HourlyTemperatures.hourlyTempHolderData, graphColor: Color.blue)
                    .previewDevice("iPhone 11 Pro Max")
                    .frame(width: UIScreen.main.bounds.width * 2)
                    .frame(height: 200)
            }

        }
        
        
    }
}


