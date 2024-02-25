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
        let uvIndexProgress = TileImageProgressView(height: 50, value: CGFloat(dailyWeather.uvIndexValue), sfSymbol: "seal.fill" , color: dailyWeather.uvIndexColor, maxValue: 11)

        let precipitationProgress = TileImageProgressView(height: 50, value: CGFloat(dailyWeather.precipitationChance * 100), sfSymbol: "drop.fill" , color: K.Colors.precipitationBlue)

        
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
                                    TileView(
                                        imageHeader: "sun.max",
                                        title: "UV Index",
                                        value: String(dailyWeather.uvIndexValue),
                                        valueDescription: dailyWeather.uvIndexCategoryDescription,
                                        dynamicImage: uvIndexProgress,
                                        staticImageName: nil,
                                        footer: dailyWeather.uvIndexActionRecommendation,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    TileView(
                                        imageHeader: "drop.fill",
                                        title: "Precipitation",
                                        value: String(dailyWeather.precipitationChance.formatted(.percent)),
                                        valueDescription: dailyWeather.precipitationType.capitalized,
                                        dynamicImage: precipitationProgress,
                                        staticImageName: nil,
                                        footer: dailyWeather.dayChanceOfPrecipitation,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    TileView(
                                        imageHeader: "sunrise",
                                        title: "Sunrise",
                                        value: dailyWeather.sun.sunriseTime,
                                        valueDescription: nil,
                                        dynamicImage: nil,
                                        staticImageName: "sunrise.fill",
                                        footer: "Dawn: " + dailyWeather.sun.dawn,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    TileView(
                                        imageHeader: "sunset",
                                        title: "Sunset",
                                        value: dailyWeather.sun.sunsetTime,
                                        valueDescription: nil,
                                        dynamicImage: nil,
                                        staticImageName: "sunset.fill",
                                        footer: "Dusk: " + dailyWeather.sun.dawn,
                                        backgroundColor: dailyWeather.backgroundColor
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
            .environmentObject(AppStateManager.shared)
    }
}



