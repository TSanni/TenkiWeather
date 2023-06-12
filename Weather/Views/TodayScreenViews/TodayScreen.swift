//
//  TodayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct TodayScreen: View {
    @EnvironmentObject var vm: WeatherKitManager
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ZStack {
                    Color(red: 0.558, green: 0.376, blue: 0.999)
                    VStack(alignment: .leading, spacing: 0.0) {

                        VStack {
                            immediateTempDetails
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                WeatherGraphView(hourlyTemperatures: vm.currentWeather.hourlyTemperatures, graphColor: Color(red: 0.558, green: 0.376, blue: 0.999))
                                    .frame(width: geo.size.width * 1.5)
                                    .padding()
                                    .offset(x: -20)
                            }
                            
                            precipitationPrediction
                                .offset(x: 10)
                                .padding(.bottom)

                        }
                        .frame(height: geo.size.height * 0.99)

                        CurrentDetailsView(title: "Current Details", details: vm.currentWeather.currentDetails)
                        
                        CustomDivider()
                        
                        WindView(windData: vm.currentWeather.todayWind, hourlyWindData: vm.currentWeather.todayHourlyWind)
                        
                        CustomDivider()
                        
                        SunsetSunriseView(sunData: vm.currentWeather.sunData, dayLight: vm.currentWeather.isDaylight)
                        
                        CustomDivider()
                        
                    }
                }
            }
        }
    }
    
    
    
    
    var immediateTempDetails: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Text(vm.currentWeather.date)
                .foregroundColor(.black)
                .shadow(color: .white.opacity(0.3), radius: 1, y: 1.7)
            Text("Day \(vm.currentWeather.todayHigh)°↑ · Night \(vm.currentWeather.todayLow)°↓")
                .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

            
            
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 7.0) {
                    HStack(alignment: .top, spacing: 0.0) {
                        Text(vm.currentWeather.currentTemperature)
                            .font(.system(size: 100))
                        
                        Text(vm.currentWeather.temperatureUnit)
                            .font(.system(size: 75))

                    }
                    
                    Text("Feels like \(vm.currentWeather.feelsLikeTemperature)°")
                }
                Spacer()
                VStack(spacing: 7.0) {
                    var symbolColors = vm.getSFColorForIcon(sfIcon: vm.currentWeather.symbol)
                    Image(systemName: "\(vm.currentWeather.symbol).fill")
                        .font(.system(size: 100))
                        .foregroundStyle(symbolColors[0], symbolColors[1], symbolColors[2])
                    
                    Text(vm.currentWeather.weatherDescription)
                }
            }
            .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

            Spacer()            
        }
        .foregroundColor(.white)
        .padding()

    }
    
    var precipitationPrediction: some View  {
        HStack {
            Image(systemName: "umbrella.fill")
            Text("\(vm.currentWeather.chanceOfPrecipitation) chance of precipitation")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
        .padding()
    }
    
}

struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodayScreen()
            .previewDevice("iPhone 12 Pro Max")
            .environmentObject(WeatherKitManager())
    }
}


