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
        .onChange(of: appStateManager.resetScrollToggle) { _ in
            showRest = false
        }
    }
    
    
    
    private var dayDetails: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Wind")
                    Text("UV index")
                    
                    if daily.dailyChanceOfPrecipitation != "0%" {
                        Text("Chance of rain")
                    }
                    Text("Sunrise/sunset")
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("\(daily.dailyWind.windDescriptionForMPH), \(daily.dailyWind.windSpeed) mph \(daily.dailyWind.windDirection.abbreviation)")
                    Text(daily.dailyUVIndex)
                    
                    if daily.dailyChanceOfPrecipitation != "0%" {
                        Text(daily.dailyChanceOfPrecipitation)
                    }
                    
                    Text("\(daily.sunEvents.sunrise), \(daily.sunEvents.sunset)")
                }
                .foregroundColor(.primary)
                
                Spacer()
                
            }
            .padding(.bottom)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(daily.hourlyTemperatures) { hour in
                        VStack {
                            Text("\(hour.temperature)°")
                            Image(systemName: WeatherManager.shared.getImage(imageName: hour.symbol))
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

                            
                            Text("\(hour.date)")
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
            
            
            
            Text(daily.dailyWeatherDescription.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var dayItemRightSide: some View {
        HStack {
            HStack {
                if daily.dailyChanceOfPrecipitation != "0%" {
                    Text("\(daily.dailyChanceOfPrecipitation)")
                        .foregroundColor(.teal)
                        .lineLimit(1)
                }
                Image(systemName: WeatherManager.shared.getImage(imageName: daily.dailySymbol))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
                
            }
            
            VStack {
                Text("\(daily.dailyHighTemp)°")
                    .foregroundColor(.primary)
                
                Text("\(daily.dailyLowTemp)°")
                    .foregroundColor(.secondary)
            }
        }
    }
    
 
}

struct DailyWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherCell(daily: DailyWeatherModel.dailyDataHolder[0], title: nil)
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(AppStateManager())
    }
}
