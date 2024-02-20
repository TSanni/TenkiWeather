//
//  TomorrowScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI


//MARK: - TomorrowScreen View
struct TomorrowScreen: View {
    @EnvironmentObject private var appStateManager: AppStateManager
    
    let dailyWeather: DailyWeatherModel
    
    
    
    var body: some View {
        GeometryReader { geo in
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        dailyWeather.backgroundColor
                        
                        // Add possible snow or rain scenes with SpriteKit
                        if let scene = dailyWeather.scene {
                            WeatherParticleEffectView(sceneImport: scene)
                        }
                        
                        VStack(alignment: .leading, spacing: 0.0) {
                            
                            VStack(alignment: .leading, spacing: 0.0) {
                                TomorrowImmediateWeatherView(tomorrowWeather: dailyWeather)
                                    .padding(.bottom)
                                    .id(0)

                                
                                Text("Hourly forecast")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateManager.blendColors(themeColor: dailyWeather.backgroundColor))
                                
                                HourlyForecastTileView(hourlyTemperatures: dailyWeather.hourlyWeather, color: dailyWeather.backgroundColor)
                                
                                
                                Text("Tomorrow's Conditions")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateManager.blendColors(themeColor: dailyWeather.backgroundColor))

                                
                                LazyVGrid(columns: appStateManager.getGridColumnAndSize(geo: geo)) {                                    
                                    UVIndexTileView(
                                        uvIndexNumberDescription: dailyWeather.uvIndexNumberDescription,
                                        uvIndexCategoryDescription: dailyWeather.uvIndexCategoryDescription,
                                        uvIndexValue: dailyWeather.uvIndexValue,
                                        uvIndexColor: dailyWeather.uvIndexColor,
                                        uvIndexActionRecommendation: dailyWeather.uvIndexActionRecommendation,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    PrecipitationTileView(
                                        precipitationDetails: dailyWeather,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    SunDataTile(
                                        sundata: dailyWeather.sun,
                                        backgroundColor: dailyWeather.backgroundColor,
                                        isSunrise: true
                                    )
                                    
                                    SunDataTile(
                                        sundata: dailyWeather.sun, 
                                        backgroundColor: dailyWeather.backgroundColor, 
                                        isSunrise: false
                                    )
                                }
                                .padding()
                                
                            }
                            
                            WindTileView(
                                windData: dailyWeather.wind,
                                hourlyWeather: dailyWeather.hourlyWeather,
                                setTodayWeather: false,
                                backgroundColor: dailyWeather.backgroundColor
                            )
                            
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


//MARK: - TomorrowScreen Preview
struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen(dailyWeather: DailyWeatherModel.placeholder)
            .environmentObject(AppStateManager())
    }
}



