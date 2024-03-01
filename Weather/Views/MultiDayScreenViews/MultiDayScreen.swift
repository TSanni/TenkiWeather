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
                    CustomDivider()
                    
                    ForEach(1..<daily.count, id: \.self) { item in
                        
                        // Getting the last item in the daily array
                        if daily.count == item+1 {
                            VStack {
                                DailyWeatherCell(daily: daily[item], title: daily[item].readableDate)
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
                                .padding()
                                
                                CustomDivider()
                                
                            }
                        } else {
                            
                            DailyWeatherCell(daily: daily[item], title: daily[item].readableDate)
                            CustomDivider()
                        }
                    }
                    .onChange(of: appStateViewModel.resetViews) { _ in
                        proxy.scrollTo(0)
                    }
                }
                .background(colorScheme == .light ? K.ColorsConstants.goodLightTheme : K.ColorsConstants.goodDarkTheme)
            }
        }
        .fullScreenCover(isPresented: $showWebView) {
            FullScreenWebView(url: "https://weatherkit.apple.com/legal-attribution.html")
        }
    }
}


//MARK: - MultiDayScreen Preview
struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiDayScreen(daily: [DailyWeatherModel.placeholder])
                .environmentObject(AppStateViewModel.shared)
    }
}
 
