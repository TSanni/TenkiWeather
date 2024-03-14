//
//  TomorrowScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI


//MARK: - TomorrowScreen View
struct TomorrowScreen: View {
    @EnvironmentObject private var appStateViewModel: AppStateViewModel
    
    let dailyWeather: DailyWeatherModel
 
    var body: some View {
        GeometryReader { geo in
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
//                        dailyWeather.backgroundColor
                        
                       
                        
                        VStack(alignment: .leading, spacing: 0.0) {
                            
                            VStack(alignment: .leading, spacing: 0.0) {
                                TomorrowImmediateWeatherView(tomorrowWeather: dailyWeather)
                                    .padding(.bottom)
                                    .id(0)

                                
                                Text("Hourly forecast")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: dailyWeather.backgroundColor))
                                
                                HourlyForecastTileView(hourlyTemperatures: dailyWeather.hourlyWeather, color: dailyWeather.backgroundColor)
                                
                                
                                Text("Tomorrow's Conditions")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: dailyWeather.backgroundColor))

                                
                                LazyVGrid(columns: appStateViewModel.getGridColumnAndSize(geo: geo)) {
                                    UVIndexTileView(
                                        uvIndexNumber: dailyWeather.uvIndexValue,
                                        uvIndexDescription: dailyWeather.uvIndexCategoryDescription,
                                        uvIndexColor: dailyWeather.uvIndexColor,
                                        uvIndexActionRecommendation: dailyWeather.uvIndexActionRecommendation,
                                        backgroundColor: dailyWeather.backgroundColor
                                    )
                                    
                                    PrecipitationTileView(
                                        precipiation: dailyWeather.precipitationChance,
                                        precipitationDescription: dailyWeather.precipitationType, 
                                        precipitationFooter: dailyWeather.dayChanceOfPrecipitation,
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
                    .onChange(of: appStateViewModel.resetViews) { _ in
                        proxy.scrollTo(0)
                    }
                }
                
            }
        }
        .background {
            dailyWeather.backgroundColor.ignoresSafeArea()
            // Add possible snow or rain scenes with SpriteKit
            if let scene = dailyWeather.scene {
                WeatherParticleEffectView(sceneImport: scene)
            }
        }
    }
    
}


//MARK: - TomorrowScreen Preview
struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen(dailyWeather: DailyWeatherModel.placeholder)
            .environmentObject(AppStateViewModel.shared)
    }
}



