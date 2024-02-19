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

    var body: some View {
        GeometryReader { geo in
            
            ScrollView(.vertical ,showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        currentWeather.backgroundColor
                        
                        // Add possible snow or rain scenes with SpriteKit
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
                                HumidityTileView(
                                    humidityDetails: currentWeather.currentDetails,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                UVIndexTileView(
                                    uvIndexDetails: currentWeather.currentDetails,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                VisibilityTileView(
                                    visibilityDetails: currentWeather.currentDetails,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                PressureTileView(
                                    pressureDetails: currentWeather.currentDetails,
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
            .environmentObject(AppStateManager())
            .environmentObject(WeatherViewModel())
    }
}
//#Preview {
//    TodayScreen(currentWeather: TodayWeatherModel.holderData, weatherAlert: nil)
//                .environmentObject(AppStateManager())
//                .environmentObject(WeatherViewModel())
//}





