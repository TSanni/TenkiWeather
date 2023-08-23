//
//  MultiDayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct MultiDayScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    let daily: [DailyWeatherModel]
    @State private var showWebView = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                DailyWeatherCell(daily: daily[0], title: "Today")
                CustomDivider()
                
                ForEach(1..<daily.count, id: \.self) { item in
                    
                    // Getting the last item in the daily array
                    if daily.count == item+1 {
                        VStack {
                            DailyWeatherCell(daily: daily[item], title: daily[item].date)
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(" Weather")
                                        .foregroundColor(.primary)
                                        .font(.caption)
                                    
                                    HStack(spacing: 0.0) {
                                        Text("Learn more about ")
                                        
                                        
                                        Text("weather data")
                                            .underline()
                                            .onTapGesture { showWebView = true }

                                    }
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal, 10)
                            
                            CustomDivider()
                            
                        }
                    } else {
                        
                        DailyWeatherCell(daily: daily[item], title: daily[item].date)
                        CustomDivider()
                    }
                }


            }
            .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)
        }
        .fullScreenCover(isPresented: $showWebView) {
            FullScreenWebView(url: "https://weatherkit.apple.com/legal-attribution.html")

        }
        
    }
}



struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
            MultiDayScreen(daily: DailyWeatherModel.dailyDataHolder)
                .previewDevice("iPhone 11 Pro Max")
    }
}
