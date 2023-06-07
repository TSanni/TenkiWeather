//
//  MultiDayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct MultiDayScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(0..<10) { item in
                    DailyWeatherCell()
                }
            }
//            .frame(height: UIScreen.main.bounds.height * 0.9)
        }
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

    }
}

struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiDayScreen()
    }
}
