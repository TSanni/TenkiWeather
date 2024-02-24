//
//  TodayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

//MARK: - Today Screen View
struct TodayScreen: View {
    @EnvironmentObject private var appStateManager: AppStateManager
    
    let currentWeather: TodayWeatherModel
    let weatherAlert: WeatherAlertModel?
    
    ///The humidity passed in is a value 0-1 representing a percentage.
    ///This function multiplies that value by 100 to get a regular number
    ///Ex) 0.2 will return 20
    func convertHumidityFromPercentToDouble(humidity: Double) -> Double {
        let newHumidity = humidity * 100
        return newHumidity
    }

    var body: some View {
        let humidity = convertHumidityFromPercentToDouble(humidity: currentWeather.humidity)
        
        let humidityProgress = TileImageProgressView(
            height: 50,
            value: humidity,
            sfSymbol: "humidity.fill",
            color: K.Colors.precipitationBlue
        )
        
        let uvIndexProgress = TileImageProgressView(height: 50, value: CGFloat(currentWeather.uvIndexValue), sfSymbol: "seal.fill" , color: currentWeather.uvIndexColor, maxValue: 11)
        
        GeometryReader { geo in
            
            ScrollView(.vertical ,showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        currentWeather.backgroundColor
                        
                        if let scene = currentWeather.scene {
                            WeatherParticleEffectView(sceneImport: scene)
                        }
                        
                        VStack(alignment: .leading, spacing: 0.0) {
                            ImmediateWeatherDetails(currentWeather: currentWeather)
                                .id(0)
                            
                            if let weatherAlert {
                                WeatherAlertTileView(weatherAlert: weatherAlert)
                            }
                            
                            Text("Hourly forecast")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateManager.blendColors(themeColor: currentWeather.backgroundColor))
                            
                            HourlyForecastTileView(
                                hourlyTemperatures: currentWeather.hourlyWeather,
                                color: currentWeather.backgroundColor
                            )
                            
                            Text("Current conditions")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateManager.blendColors(themeColor: currentWeather.backgroundColor))
                            
                            LazyVGrid(columns: appStateManager.getGridColumnAndSize(geo: geo)) {
                                
                                TileView(
                                    imageHeader: "humidity.fill",
                                    title: "Humidity",
                                    value: currentWeather.humidityPercentage,
                                    valueDescription: nil,
                                    dynamicImage: humidityProgress,
                                    footer: currentWeather.dewPointDescription,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                TileView(
                                    imageHeader: "sun.max",
                                    title: "UV Index",
                                    value: String(currentWeather.uvIndexValue),
                                    valueDescription: currentWeather.uvIndexCategoryDescription,
                                    dynamicImage: uvIndexProgress,
                                    footer: currentWeather.uvIndexActionRecommendation,
                                    backgroundColor: currentWeather.backgroundColor)
                                
                                VisibilityTileView(
                                    visibilityValue: currentWeather.visibilityValue,
                                    visiblityDescription: currentWeather.visiblityDescription,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                PressureTileView(
                                    pressureDetails: currentWeather,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                            }
                            .padding()
                            
                            WindTileView(
                                windData: currentWeather.wind,
                                hourlyWeather: currentWeather.hourlyWeather,
                                setTodayWeather: true,
                                backgroundColor: currentWeather.backgroundColor
                            )
                            
                            Text("Sun Data")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateManager.blendColors(themeColor: currentWeather.backgroundColor))
                            
                            LazyVGrid(columns: appStateManager.getGridColumnAndSize(geo: geo)) {
                                SunDataTile(
                                    sundata: currentWeather.sunData,
                                    backgroundColor: currentWeather.backgroundColor,
                                    isSunrise: true
                                )
                                
                                SunDataTile(
                                    sundata: currentWeather.sunData,
                                    backgroundColor: currentWeather.backgroundColor,
                                    isSunrise: false
                                )
                            }
                            .padding()
                            .padding(.bottom)
                        }
                    }
                    .onChange(of: appStateManager.resetViews) { _ in
                        proxy.scrollTo(0)
                    }
                }
            }
        }
    }
      
}





//MARK: - TodayScreen Preview
struct TodayScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodayScreen(currentWeather: TodayWeatherModel.holderData, weatherAlert: nil)
            .environmentObject(AppStateManager.shared)
            .environmentObject(WeatherViewModel.shared)
    }
}
