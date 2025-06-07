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
    let militaryTime = UserDefaults.standard.bool(forKey: K.UserDefaultKeys.timePreferenceKey)

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
        .background(Color.tenDayBarColor.brightness(-0.1))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .padding(.horizontal)
        .shadow(color: .black, radius: 0, y: 0.5)
        .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
            showRest = false
        }
    }
        
    private var dayDetails: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            
            HStack {
                Text("Wind")
                Spacer()
                Text("\(daily.wind.windDescription), \(daily.wind.windSpeed) \(daily.wind.speedUnit) \(daily.wind.compassDirection.abbreviation)")
            }
            
            HStack {
                Text("UV index")
                Spacer()
                Text(daily.uvIndexCategoryDescription + "," + daily.uvIndexNumberDescription)
            }
            
            HStack {
                Text("Precipitation")
                Spacer()
                Text(daily.dayChanceOfPrecipitation)
            }
            
            HStack {
                Text("Sunrise/sunset")
                Spacer()
                Text("\(daily.sun.sunriseTime), \(daily.sun.sunsetTime)")
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
                            
                            if militaryTime {
                                let time = hour.readableDate
                                let newTime = time.dropLast(3)
                                Text(newTime)
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            } else {
                                Text(hour.readableDate)
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .foregroundColor(.white)
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

#Preview {
    ZStack {
        Color.tenDayBarColor
        VStack {
            DailyWeatherCell(daily:DailyWeatherModelPlaceHolder.placeholder, title: "nil")
                .environmentObject(AppStateViewModel.preview)
            
            DailyWeatherCell(daily: DailyWeatherModelPlaceHolder.placeholder, title: "nil")
                .environmentObject(AppStateViewModel.preview)
        }
    }
}
