//
//  TodayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI


struct TodayScreen: View {
    @EnvironmentObject private var appStateManager: AppStateManager

    let currentWeather: TodayWeatherModel
    let weatherAlert: WeatherAlertModel?
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical ,showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        currentWeather.backgroundColor
                        VStack(alignment: .leading, spacing: 0.0) {

                            VStack {
                                immediateTempDetails
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    ScrollViewReader { proxy2 in
                                        HStack {
                                            HStack {}
                                                .id(1)
                                            WeatherGraphView(hourlyTemperatures: currentWeather.hourlyTemperatures, graphColor: currentWeather.backgroundColor)
                                                .frame(width: geo.size.width * 3.5)
                                                .frame(height: geo.size.height * 0.3)

                                        }
                                        .onChange(of: appStateManager.resetScrollToggle) { _ in
                                            proxy2.scrollTo(1)
                                            
                                        }
                    
                                    }
            
                                }
                                
                                
                                precipitationPrediction
                                    .offset(x: 10)
                                    .padding(.bottom)
                            }
                            .frame(height: geo.size.height)
                            .id(0)
                            
                            if let weatherAlert {
                                WeatherAlertView(weatherAlert: weatherAlert)
                            }

                            CustomDivider()

                            CurrentDetailsView(title: "Current Details", details: currentWeather.currentDetails)
                            
                            CustomDivider()
                            
                            WindView(windData: currentWeather.todayWind, hourlyWindData: currentWeather.todayHourlyWind, setTodayWeather: true, geo: geo)
                            
                            
                            CustomDivider()
                            
                            SunsetSunriseView(sunData: currentWeather.sunData, dayLight: currentWeather.isDaylight)
                            
                            CustomDivider()
                        }
                    }
                    .onChange(of: appStateManager.resetScrollToggle) { _ in
                        proxy.scrollTo(0)
                        
                    }
                }
            }
        }
    }
    
    
    
    
    var immediateTempDetails: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Text(currentWeather.date)
                .foregroundColor(.black)
                .shadow(color: .white.opacity(0.3), radius: 1, y: 1.7)
            Text("Day \(currentWeather.todayHigh)°↑ · Night \(currentWeather.todayLow)°↓")
                .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

            
            
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 7.0) {
                    HStack(alignment: .top, spacing: 0.0) {
                        Text(currentWeather.currentTemperature)
                            .font(.system(size: 100))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                        
                        Text(currentWeather.temperatureUnit)
                            .font(.system(size: 75))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)

                    }
                    
                    Text("Feels like \(currentWeather.feelsLikeTemperature)°")
                }
                Spacer()
                VStack(spacing: 7.0) {
                    
                    Image(systemName: WeatherManager.shared.getImage(imageName: currentWeather.symbol))
                        .renderingMode(.original)
                        .font(.system(size: 100))
                                        
                    Text(currentWeather.weatherDescription.description)
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
            Text("\(currentWeather.chanceOfPrecipitation) chance of precipitation")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
        .padding()
    }

    
}

struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodayScreen(currentWeather: TodayWeatherModel.holderData, weatherAlert: nil)
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(AppStateManager())
    }
}


