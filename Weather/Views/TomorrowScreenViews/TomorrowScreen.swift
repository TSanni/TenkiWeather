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
    
    let tomorrowWeather: TomorrowWeatherModel
    
    
    
    var body: some View {
        GeometryReader { geo in
            let tileSize = appStateManager.fortyFivePercentTileSize(geo: geo)
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        tomorrowWeather.backgroundColor
                        
                        // Add possible snow or rain scenes with SpriteKit
                        if let scene = tomorrowWeather.scene {
                            WeatherParticleEffectView(sceneImport: scene)
                        }
                        
                        VStack(alignment: .leading, spacing: 0.0) {
                            
                            VStack(alignment: .leading, spacing: 0.0) {
                                TomorrowImmediateWeatherView(tomorrowWeather: tomorrowWeather)
                                    .padding(.bottom)
                                    .id(0)

                                
                                Text("Hourly forecast")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateManager.blendColors(themeColor: tomorrowWeather.backgroundColor))
                                
                                HourlyForecastTileView(hourlyTemperatures: tomorrowWeather.hourlyTemperatures, color: tomorrowWeather.backgroundColor)
                                
                                
                                Text("Tomorrow's Conditions")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateManager.blendColors(themeColor: tomorrowWeather.backgroundColor))

                                
                                LazyVGrid(columns: appStateManager.getGridColumnAndSize(geo: geo)) {
                                    
                                    UVIndexTileView(uvIndexDetails: tomorrowWeather.tomorrowDetails, backgroundColor: tomorrowWeather.backgroundColor)
                                    
                                    PrecipitationTileView(
                                        precipitationDetails: tomorrowWeather,
                                        backgroundColor: tomorrowWeather.backgroundColor
                                    )
                                    
                                    
                                    SunDataTile(
                                        sundata: tomorrowWeather.sunData,
                                        backgroundColor: tomorrowWeather.backgroundColor,
                                        isSunrise: true
                                    )
                                    
                                    SunDataTile(
                                        sundata: tomorrowWeather.sunData, 
                                        backgroundColor: tomorrowWeather.backgroundColor, 
                                        isSunrise: false
                                    )
                                }
                                .padding()
                                
                            }
                            
                            WindTileView(
                                windData: tomorrowWeather.tomorrowWind,
                                hourlyWindData: tomorrowWeather.tomorrowHourlyWind,
                                setTodayWeather: false,
                                backgroundColor: tomorrowWeather.backgroundColor
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
        TomorrowScreen(tomorrowWeather: TomorrowWeatherModel.tomorrowDataHolder)
            .environmentObject(AppStateManager())
    }
}



