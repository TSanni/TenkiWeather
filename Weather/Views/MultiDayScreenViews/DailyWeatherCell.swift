//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct DailyWeatherCell: View {
    @State private var showRest: Bool = false
    let daily: DailyWeatherModel
    let title: String?
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Color.teal.opacity(0.000001)
                    HStack {
                        VStack(alignment: .leading) {
                            
                            if let title = title {
                                Text(title)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            } else {
                                Text(daily.date)
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            }
                            

                            
                            Text(daily.dailyWeatherDescription.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack {
                                if daily.dailyChanceOfPrecipitation != "0%" {
                                    Text("\(daily.dailyChanceOfPrecipitation)")
                                        .foregroundColor(.teal)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                Image(systemName: "\(daily.dailySymbol).fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .brightness(-0.07)
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
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
                .onTapGesture {
                      withAnimation(.linear(duration: 0.2)) {
                          showRest.toggle()
                      }
                  }
                
                
                if showRest {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Wind")
//                            Text("Humidity")
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
//                            Text("77%")
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
                    .transition(.identity)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(daily.hourlyTemperatures) { hour in
                                VStack {
                                    Text("\(hour.temperature)°")
                                    Image(systemName: "\(hour.symbol).fill")
                                        .resizable()
                                        .renderingMode(.original)
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .brightness(-0.07)

                                    Text("\(hour.date)")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                    
                                }
                            }
                        }
                    }
                    .transition(.identity)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            
            CustomDivider()
        }

    }
}

struct DailyWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherCell(daily: DailyWeatherModel.dailyDataHolder, title: nil)
            .previewDevice("iPhone 12 Pro Max")
    }
}
