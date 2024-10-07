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
 
                        VStack(alignment: .leading, spacing: 0.0) {
                            
                            VStack(alignment: .leading, spacing: 0.0) {
                                TomorrowImmediateWeatherView(tomorrowWeather: dailyWeather)
                                    .padding(.bottom)
                                    .id(0)

                                
                                Text("Hourly forecast")
                                    .padding(.horizontal)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: dailyWeather.backgroundColor))
                                
                                HourlyForecastTileView(
                                    hourlyTemperatures: dailyWeather.hourlyWeather,
                                    color: dailyWeather.backgroundColor,
                                    forToday: false
                                )
                                
                                
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
                                        sunTime: dailyWeather.sun.sunriseTime,
                                        description: dailyWeather.sun.dawnDescription,
                                        backgroundColor: dailyWeather.backgroundColor,
                                        isSunrise: true
                                    )
                                    
                                    SunDataTile(
                                        sunTime: dailyWeather.sun.sunsetTime,
                                        description: dailyWeather.sun.duskDescription,
                                        backgroundColor: dailyWeather.backgroundColor,
                                        isSunrise: false
                                    )
                                }
                                .padding()
                                .lineLimit(nil)
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
    }
    
}


//MARK: - TomorrowScreen Preview
struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen(dailyWeather: DailyWeatherModelPlaceHolder.placeholder)
            .environmentObject(AppStateViewModel.shared)
    }
}



