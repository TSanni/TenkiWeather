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
                
                ForEach(1..<daily.count, id: \.self) { item in
                    DailyWeatherCell(daily: daily[item], title: daily[item].date)
                }

                    HStack {
                        Text("")
                        Spacer()
                        Text(" Weather")
                            .foregroundColor(.primary)
                            .font(.headline)
                    }
                    .padding(10)
                    .onTapGesture { showWebView = true }
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
        NavigationView {
            MultiDayScreen(daily: [DailyWeatherModel.dailyDataHolder, DailyWeatherModel.dailyDataHolder, DailyWeatherModel.dailyDataHolder])
                .previewDevice("iPhone 11 Pro Max")
        }
    }
}
