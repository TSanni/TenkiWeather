//
//  WindView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI

struct WindView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vm: WeatherKitManager
    let windData: WindData
    let hourlyWindData: [WindData]
    let setTodayWeather: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Wind")
                .bold()
                .padding(.bottom)
            
            if setTodayWeather {
                todayData
            } else {
                tomorrowData
            }

            
            ScrollView(.horizontal, showsIndicators: false) {
                WindBarGraph(hourlyWind: hourlyWindData)
                    .frame(width: UIScreen.main.bounds.width * 2)
            }
            
        }
        .padding()
        .padding(.top)
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))
        
    }
    
    
    
    var todayData: some View {
        HStack(spacing: 30.0) {
            HStack {
                Text(windData.windSpeed)
                    .bold()
                    .font(.system(size: 70))
                    .foregroundColor(windData.windColor)
                
                VStack {
                    Image(systemName: "location.fill")
                        .rotationEffect(.degrees(vm.getRotation(direction: windData.windDirection) + 180))
                    Text("mph")
                }
                .foregroundColor(.secondary)
            }
            
            
            
            VStack(alignment: .leading) {
//                    Text("Light")
                Text(windData.windDescriptionForMPH)
                    .font(.largeTitle)
                    .fontWeight(.light)
                Text("Now · From \(windData.readableWindDirection)").foregroundColor(.secondary)
            }
        }
    }
    
    var tomorrowData: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text(windData.windDescriptionForMPH)
                .fontWeight(.light)
                .font(.title)
            Text("Average of about \(windData.windSpeed)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        WindView(windData: WindData.windDataHolder, hourlyWindData: [WindData.windDataHolder], setTodayWeather: false)
            .environmentObject(WeatherKitManager())
        
    }
}
