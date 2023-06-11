//
//  TomorrowScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct TomorrowScreen: View {
    @EnvironmentObject var vm: WeatherKitManager

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ZStack {
                    Color(red: 0.587, green: 0.375, blue: 0.555)
        
                    VStack(alignment: .leading, spacing: 0.0) {
                        
                        VStack {
                            immediateTomorrowDetails
                            
                            ScrollView(.horizontal, showsIndicators: false) {
//                                WeatherGraphView(graphColor: Color(red: 0.587, green: 0.375, blue: 0.555))
//                                    .frame(width: geo.size.width * 1.5)
//                                    .padding()
//                                    .offset(x: -30)
                            }
                            
                            precipitationPrediction
                                .offset(x: 10)
                                .padding(.bottom)
                            
                        }
                        .frame(height: geo.size.height)
                        
                        CurrentDetailsView(title: "Details", details: vm.tomorrowWeather.tomorrowDetails)
                        
                        CustomDivider()
                        
                        WindView(windData: vm.tomorrowWeather.tomorrowWind, hourlyWindData: vm.tomorrowWeather.tomorrowHourlyWind)
                        
                        CustomDivider()
                    }
                }
                
                
            }
        }
    }
    
    
    var immediateTomorrowDetails: some View {
        VStack(alignment: .leading) {
            Text("Monday, July 7")
                .foregroundColor(.black)
                .shadow(color: .white.opacity(0.7), radius: 1, y: 1.7)
            HStack {
                VStack(alignment: .leading) {
                    Text("Day 77°↑ · Night 17°↓")
                        .font(.headline)
                    Text("Partly cloudy")
                        .font(.largeTitle)
                }
                
                Spacer()
                
                Image(systemName: "sun.max")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75)
                
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
        .padding()
    }
    
    var precipitationPrediction: some View  {
        HStack {
            Image(systemName: "umbrella")
            Text("717% chance of precipitation tonight")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
        .padding()
    }
    
    
    
}

struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen()
            .environmentObject(WeatherKitManager())
    }
}
