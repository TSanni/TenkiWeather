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
    let dailyWeather: [DailyWeatherModel]
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
                                color: currentWeather.backgroundColor,
                                forToday: true
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
                                
                                PrecipitationTileView(
                                    precipitation: dailyWeather[0].precipitation,
                                    precipiationChance: dailyWeather[0].precipitationChance,
                                    precipitationDescription: dailyWeather[0].precipitationType,
                                    precipitationFooter: dailyWeather[0].dayChanceOfPrecipitation,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                VisibilityTileView(
                                    visibilityValue: currentWeather.visibilityValue,
                                    visiblityDescription: currentWeather.visiblityDescription,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                                
                                PressureTileView(
                                    pressureString: currentWeather.pressureString,
                                    pressureValue: currentWeather.pressureValue,
                                    pressureDescription: currentWeather.pressureDescription,
                                    backgroundColor: currentWeather.backgroundColor,
                                    inchesOfMercuryPressureValue: currentWeather.pressure.converted(to: .inchesOfMercury).value
                                )
                                
                                MoonTileView(
                                    moonrise: currentWeather.moonData.moonriseTime,
                                    moonset: currentWeather.moonData.moonsetTime,
                                    moonPhase: currentWeather.moonData.phase.description,
                                    moonPhaseImage: currentWeather.moonData.moonPhaseImage,
                                    backgroundColor: currentWeather.backgroundColor
                                )
                            }
                            .padding()
                            .lineLimit(nil)
                            
                            Text("Hourly Details")
                                .padding(.horizontal)
                                .fontWeight(.semibold)
                                .foregroundStyle(appStateViewModel.mixColorWith70PercentWhite(themeColor: currentWeather.backgroundColor))
                            
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
                    .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
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
        TodayScreen(currentWeather: TodayWeatherModelPlaceHolder.holderData, dailyWeather: DailyWeatherModelPlaceHolder.placeholderArray, weatherAlert: nil)
            .environmentObject(AppStateViewModel.preview)
            .environmentObject(WeatherViewModel.preview)
            .environmentObject(CoreLocationViewModel.preview)
    }
}
