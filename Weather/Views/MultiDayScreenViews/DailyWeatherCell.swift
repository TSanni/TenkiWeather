//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct DailyWeatherCell: View {
    @EnvironmentObject private var appStateManager: AppStateManager
    @State private var showRest: Bool = false
    let daily: DailyWeatherModel
    let title: String?
    
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    dayItemLeftSide
                    
                    Spacer()
                    
                    dayItemRightSide
                    
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showRest.toggle()
                    }
                }
                
                
                if showRest {
                    dayDetails
                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .onChange(of: appStateManager.resetViews) { _ in
            showRest = false
        }
    }
    
    
    
    private var dayDetails: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Wind")
                    Text("UV index")
                    
                    if daily.dayChanceOfPrecipitation != "0%" {
                        Text("Chance of rain")
                    }
                    Text("Sunrise/sunset")
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("\(daily.tomorrowWind.windDescription), \(daily.tomorrowWind.windSpeed) \(daily.tomorrowWind.speedUnit) \(daily.tomorrowWind.compassDirection.abbreviation)")
                    Text(daily.uvIndexCategoryType + "," + daily.uvIndexNumber)
                    
                    if daily.dayChanceOfPrecipitation != "0%" {
                        Text(daily.dayChanceOfPrecipitation)
                    }
                    
                    Text("\(daily.sunData.sunriseTime), \(daily.sunData.sunsetTime)")
                }
                .foregroundColor(.primary)
                
                Spacer()
                
            }
            .padding(.bottom)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(daily.hourlyWeather) { hour in
                        VStack {
                            Text("\(hour.hourTemperature)°")
                            Image(systemName: WeatherManager.shared.getImage(imageName: hour.symbol))
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

                            
                            Text(hour.readableDate)
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    private var dayItemLeftSide: some View {
        VStack(alignment: .leading) {
            
            if let title = title {
                Text(title)
                    .foregroundColor(.primary)
                    .font(.headline)
            } 
            
            
            
            Text(daily.dayWeatherDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var dayItemRightSide: some View {
        HStack {
            HStack {
                if daily.dayChanceOfPrecipitation != "0%" {
                    Text(daily.dayChanceOfPrecipitation)
                        .foregroundColor(.teal)
                        .lineLimit(1)
                }
                Image(systemName: WeatherManager.shared.getImage(imageName: daily.symbolName))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
                
            }
            
            VStack {
                Text("\(daily.dayHigh)°")
                    .foregroundColor(.primary)
                
                Text("\(daily.dayLow)°")
                    .foregroundColor(.secondary)
            }
        }
    }
    
 
}

struct DailyWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherCell(daily: DailyWeatherModel.placeholder, title: nil)
            .environmentObject(AppStateManager())
    }
}
