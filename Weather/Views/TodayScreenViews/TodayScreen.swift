//
//  TodayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

//MARK: - Today Screen View
struct TodayScreen: View {
    @EnvironmentObject private var appStateViewModel: AppStateViewModel
    
    let currentWeather: TodayWeatherModel
    let weatherAlert: WeatherAlertModel?
    
    var body: some View {
        GeometryReader { geo in
            
            ScrollView(.vertical ,showsIndicators: false) {
                ScrollViewReader { proxy in
                    ZStack {
                        VStack(alignment: .leading, spacing: 0.0) {
                            ImmediateWeatherDetails(currentWeather: currentWeather)
                                .id(0)
                            
                            if let weatherAlert {
                                WeatherAlertTileView(weatherAlert: weatherAlert)
                            }
                            
                            Text("Hourly forecast")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    appStateViewModel.mixColorWith70PercentWhite(themeColor: currentWeather.backgroundColor)
                                )
                            
                            HourlyForecastTileView(
                                hourlyTemperatures: currentWeather.hourlyWeather,
                                color: currentWeather.backgroundColor
                            )
                            
                            Text("Current conditions")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: currentWeather.backgroundColor))
                            
                            LazyVGrid(columns: appStateViewModel.getGridColumnAndSize(geo: geo)) {
                                HumidityTileView(
                                    humidity: currentWeather.humidity,
                                    dewPointDescription: currentWeather.dewPointDescription,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                UVIndexTileView(
                                    uvIndexNumber: currentWeather.uvIndexValue,
                                    uvIndexDescription: currentWeather.uvIndexCategoryDescription,
                                    uvIndexColor: currentWeather.uvIndexColor,
                                    uvIndexActionRecommendation: currentWeather.uvIndexActionRecommendation,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
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
                            .lineLimit(nil)
                            
                            WindTileView(
                                windData: currentWeather.wind,
                                hourlyWeather: currentWeather.hourlyWeather,
                                setTodayWeather: true,
                                backgroundColor: currentWeather.backgroundColor
                            )
                            
                            Text("Sun Data")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: currentWeather.backgroundColor))
                            
                            LazyVGrid(columns: appStateViewModel.getGridColumnAndSize(geo: geo)) {
                                SunDataTile(
                                    sunTime: currentWeather.sunData.sunriseTime,
                                    description: currentWeather.sunData.dawnDescription,
                                    backgroundColor: currentWeather.backgroundColor,
                                    isSunrise: true
                                )
                                
                                SunDataTile(
                                    sunTime: currentWeather.sunData.sunsetTime,
                                    description: currentWeather.sunData.duskDescription,
                                    backgroundColor: currentWeather.backgroundColor,
                                    isSunrise: false
                                )
                            }
                            .padding()
                            .padding(.bottom)
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





//MARK: - TodayScreen Preview
#Preview {
    NavigationStack {
        TodayScreen(currentWeather: TodayWeatherModelPlaceHolder.holderData, weatherAlert: nil)
            .environmentObject(AppStateViewModel.shared)
            .environmentObject(WeatherViewModel.shared)
            .environmentObject(CoreLocationViewModel.shared)
    }
}
