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
                ForEach(daily) { item in
                    DailyWeatherCell(daily: item)
                }
            }
        }
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

    }
}

struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiDayScreen(daily: [DailyWeatherModel.dailyDataHolder])
    }
}
