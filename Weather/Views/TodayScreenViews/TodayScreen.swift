//
//  TodayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct TodayScreen: View {
//    @EnvironmentObject var vm: WeatherKitManager
    let currentWeather: TodayWeatherModel
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ZStack {
                    currentWeather.backgroundColor
                    VStack(alignment: .leading, spacing: 0.0) {

                        VStack {
                            immediateTempDetails
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                WeatherGraphView(hourlyTemperatures: currentWeather.hourlyTemperatures, graphColor: currentWeather.backgroundColor)
                                    .frame(width: geo.size.width * 1.5)
                                    .frame(height: geo.size.height * 0.3)
                                    .padding(.leading)
                                    .offset(x: -20)
                            }
                            
                            precipitationPrediction
                                .offset(x: 10)
                                .padding(.bottom)
                        }
                        .frame(height: geo.size.height * 0.99)

                        CurrentDetailsView(title: "Current Details", details: currentWeather.currentDetails)
                        
                        CustomDivider()
                        
                        WindView(windData: currentWeather.todayWind, hourlyWindData: currentWeather.todayHourlyWind, setTodayWeather: true)
                        
                        CustomDivider()
                        
                        SunsetSunriseView(sunData: currentWeather.sunData, dayLight: currentWeather.isDaylight)
                        
                        CustomDivider()
                        
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
//                    let symbolColors = vm.getSFColorForIcon(sfIcon: vm.currentWeather.symbol)
                    
                    Image(systemName: WeatherManager.shared.getImage(imageName: currentWeather.symbol))
                        .renderingMode(.original)
                        .font(.system(size: 100))
                    
//                        .foregroundStyle(symbolColors[0], symbolColors[1], symbolColors[2])
                    
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
    
    
    
    
    
//    /// Manually checks for SF Symbols that do not have the fill option and returns that image without .fill added.
//    /// Otherwise, .fill is added to the end of the symbol name
//    //TODO: Add more sf symbols
//    private func getImage(imageName: String) -> String {
//        switch imageName {
//            case "wind":
//                return imageName
//            case "snowflake":
//                return imageName
//            case "tornado":
//                return imageName
//
//            default:
//                return imageName + ".fill"
//        }
//    }
    
}

struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodayScreen(currentWeather: TodayWeatherModel.holderData)
            .previewDevice("iPhone 12 Pro Max")
//            .environmentObject(WeatherKitManager())
    }
}


