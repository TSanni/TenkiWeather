//
//  MultiDayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

//MARK: - MultiDayScreen View
struct MultiDayScreen: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var appStateViewModel: AppStateViewModel

    @State private var showWebView = false
    let daily: [DailyWeatherModel]

    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack {
                    DailyWeatherCell(daily: daily[0], title: "Today")
                        .id(0)
                    
                    ForEach(1..<daily.count, id: \.self) { item in
                        
                        // Getting the last item in the daily array
                        if daily.count == item+1 {
                            VStack {
                                DailyWeatherCell(daily: daily[item], title: daily[item].readableDate)
                                HStack {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(" Weather")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        
                                        HStack(spacing: 0.0) {
                                            Text("Learn more about ")
                                            
                                            
                                            Text("weather data")
                                                .underline()
                                                .onTapGesture { showWebView = true }

                                        }
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                    }
                                }
                                .padding()
                            }
                        } else {
                            DailyWeatherCell(daily: daily[item], title: daily[item].readableDate)
                        }
                    }
                    .onChange(of: appStateViewModel.resetViews) { oldValue, newValue in
                        proxy.scrollTo(0)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showWebView) {
            FullScreenWebView(url: K.legalAttributionURL)
        }
        .background(Color.tenDayBarColor)
    }
}


//MARK: - MultiDayScreen Preview

#Preview {
    MultiDayScreen(daily: DailyWeatherModelPlaceHolder.placeholderArray)
            .environmentObject(AppStateViewModel.preview)
}
 
