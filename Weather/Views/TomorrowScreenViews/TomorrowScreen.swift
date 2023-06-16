//
//  TomorrowScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct TomorrowScreen: View {
    @EnvironmentObject var vm: WeatherKitManager
    let tomorrowWeather: TomorrowWeatherModel
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ZStack {
                    tomorrowWeather.backgroundColor
        
                    VStack(alignment: .leading, spacing: 0.0) {
                        
                        VStack {
                            immediateTomorrowDetails
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                WeatherGraphView(hourlyTemperatures: tomorrowWeather.hourlyTemperatures, graphColor: tomorrowWeather.backgroundColor)
                                    .frame(width: geo.size.width * 1.5)
                                    .frame(height: geo.size.height * 0.3)
                                    .padding(.leading)
                                    .offset(x: -20)
                            }
                            
                            precipitationPrediction
                                .offset(x: 10)
                                .padding(.bottom)
                            
                        }
                        .frame(height: geo.size.height)
                        
                        CurrentDetailsView(title: "Details", details: vm.tomorrowWeather.tomorrowDetails)
                        
                        CustomDivider()
                        
                        WindView(windData: vm.tomorrowWeather.tomorrowWind, hourlyWindData: vm.tomorrowWeather.tomorrowHourlyWind, setTodayWeather: false)
                        
                        CustomDivider()
                    }
                }
                
                
            }
        }
    }
    
    
    var immediateTomorrowDetails: some View {
        VStack(alignment: .leading) {
            Text(tomorrowWeather.date)
                .foregroundColor(.black)
                .shadow(color: .white.opacity(0.7), radius: 1, y: 1.7)
            HStack {
                VStack(alignment: .leading) {
                    Text("Day \(tomorrowWeather.tomorrowHigh)°↑ · Night \(tomorrowWeather.tomorrowLow)°↓")
                        .font(.headline)
                    Text(tomorrowWeather.tomorrowWeatherDescription.description)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                }
                
                Spacer()
                
                Image(systemName: "\(tomorrowWeather.tomorrowSymbol).fill")
                    .renderingMode(.original)
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
            Text("\(tomorrowWeather.tomorrowChanceOfPrecipitation) chance of precipitation tonight")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
        .padding()
    }
    
    
    
}

struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen(tomorrowWeather: TomorrowWeatherModel.tomorrowDataHolder)
            .environmentObject(WeatherKitManager())
    }
}
