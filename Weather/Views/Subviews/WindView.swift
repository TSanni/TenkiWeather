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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Wind")
                .bold()
            
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                WindBarGraph(hourlyWind: hourlyWindData)
                    .frame(width: UIScreen.main.bounds.width * 2)
//                    .frame(height: 200)
            }
            
        }
        .padding()
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))
        
    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        WindView(windData: WindData.windDataHolder, hourlyWindData: [WindData.windDataHolder])
            .environmentObject(WeatherKitManager())
        
    }
}
