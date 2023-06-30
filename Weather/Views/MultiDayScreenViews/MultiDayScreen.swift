//
//  MultiDayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct MultiDayScreen: View {
//    @EnvironmentObject var vm: WeatherKitManager
    @Environment(\.colorScheme) var colorScheme
    let daily: [DailyWeatherModel]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                DailyWeatherCell(daily: daily[0], title: "Today")
                
                ForEach(1..<daily.count, id: \.self) { item in
                    DailyWeatherCell(daily: daily[item], title: nil)
                }
            }
            .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)
        }
        
    }
}

struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiDayScreen(daily: [DailyWeatherModel.dailyDataHolder])
            .previewDevice("iPhone 12 Pro Max")
    }
}
