//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct DailyWeatherCell: View {
    @EnvironmentObject private var appStateViewModel: AppStateViewModel
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
                .padding(.vertical, 10)
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
        .onChange(of: appStateViewModel.resetViews) { _ in
            showRest = false
        }
        .background(K.ColorsConstants.tenDayBarColor.brightness(-0.1))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .padding(.horizontal)
        .shadow(color: .black, radius: 1, y: 1)
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
                .foregroundColor(.gray)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("\(daily.wind.windDescription), \(daily.wind.windSpeed) \(daily.wind.speedUnit) \(daily.wind.compassDirection.abbreviation)")
                    Text(daily.uvIndexCategoryDescription + "," + daily.uvIndexNumberDescription)
                    
                    if daily.dayChanceOfPrecipitation != "0%" {
                        Text(daily.dayChanceOfPrecipitation)
                    }
                    
                    Text("\(daily.sun.sunriseTime), \(daily.sun.sunsetTime)")
                }
                .foregroundColor(.white)
                
                Spacer()
                
            }
            .padding(.bottom)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(daily.hourlyWeather) { hour in
                        VStack {
                            Text("\(hour.hourTemperature)°")
                                .foregroundStyle(.white)
                            Image(systemName: Helper.getImage(imageName: hour.symbol))
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)

                            
                            Text(hour.readableDate)
                                .font(.callout)
                                .foregroundColor(.gray)
                            
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
                    .foregroundColor(.white)
                    .font(.headline)
            } 
            
            
            
            Text(daily.dayWeatherDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var dayItemRightSide: some View {
        HStack {
            HStack {
                if daily.precipitationChance != 0 {
                    Text(daily.precipitationChance.formatted(.percent))
                        .foregroundColor(.teal)
                        .lineLimit(1)
                }
                Image(systemName: Helper.getImage(imageName: daily.symbolName))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.5), radius: 1, y: 1.7)
                
            }
            
            VStack {
                Text("\(daily.dayHigh)°")
                    .foregroundColor(.white)
                
                Text("\(daily.dayLow)°")
                    .foregroundColor(.gray)
            }
        }
    }
    
 
}

struct DailyWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            K.ColorsConstants.haze
            VStack {
                DailyWeatherCell(daily: DailyWeatherModel.placeholder, title: "nil")
                    .environmentObject(AppStateViewModel.shared)
                
                DailyWeatherCell(daily: DailyWeatherModel.placeholder, title: "nil")
                    .environmentObject(AppStateViewModel.shared)
            }
        }
    }
}
