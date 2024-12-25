//
//  HourlyForecastTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/22/24.
//

import SwiftUI




struct HourlyForecastTileView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    let hourlyTemperatures: [HourlyWeatherModel]
    let color: Color
    let deviceType = UIDevice.current.userInterfaceIdiom
    let forToday: Bool
    let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)

    var body: some View {
        let color = appStateViewModel.blendColorWith20PercentWhite(themeColor: color)
        
        VStack(alignment: .leading) {
            if let forecast = weatherViewModel.currentWeather.getForecastUsingHourlyWeather, forToday == true {
                VStack(alignment: .leading) {
                    Text(forecast)
                        .font(.subheadline)
                        .lineLimit(3)
                        .minimumScaleFactor(1)
                    CustomDivider()
                }
                .padding([.top, .horizontal], 15)
   
            }

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            EmptyView()
                                .id(0)
                            ForEach(hourlyTemperatures) { item in
                                let imageName = appStateViewModel.fillImageToPrepareForRendering(symbol: item.symbol)
                                
                                VStack(spacing: 7.0) {
                                    
                                    if militaryTime {
                                        let time = item.readableDate
                                        let newTime = time.dropLast(3)
                                        Text(newTime)
                                            .font(.callout)
                                    } else {
                                        Text(item.readableDate)
                                            .font(.caption)
                                    }
                                    
                                    
                                    
                                    Image(systemName: imageName)
                                        .renderingMode(.original)
                                        .frame(width: 25, height: 25)
                                        .font(.title3)
                                    
                                    Text(item.hourTemperature + "°")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                    
                                    
                                }
                                .padding(.top)
                                .padding(.horizontal, 10)
                                .frame(width: deviceType == .pad ? 100 : 63)
                            }
                        }
                        
                        HourlyForecastLineGraphView(hourlyTemperatures: hourlyTemperatures)
                            .frame(height: 50)
                        
                        HStack {
                            ForEach(hourlyTemperatures) { item in
                                HStack(spacing: 2) {
                                    ImageProgressView(
                                        height: 15,
                                        value: item.precipitationChance * 100,
                                        sfSymbol: "drop.fill",
                                        color: K.ColorsConstants.precipitationBlue
                                    )
                                    Text(item.chanceOfPrecipitation)
                                        .font(.caption2)
                                }
                                .padding([.horizontal, .bottom], 10)
                                .frame(width: deviceType == .pad ? 100 : 63)
                            }
                        }
                    }
                    .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
                        proxy.scrollTo(0)
                    }
                }
            }

        }
        .foregroundStyle(.white)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
        .padding()
        .shadow(color: .black, radius: 0, y: 0.5)
        .shadow(radius: 3)
    }
}

//MARK: - Preview
#Preview {
    ZStack {
        K.ColorsConstants.haze.brightness(0.1)
        HourlyForecastTileView(
            hourlyTemperatures: HourlyWeatherModelPlaceholder.hourlyTempHolderDataArray,
            color: K.ColorsConstants.haze, forToday: true
        )
        .environmentObject(AppStateViewModel.shared)
        .environmentObject(WeatherViewModel.shared)
    }
}
