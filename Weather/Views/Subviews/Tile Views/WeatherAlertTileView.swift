//
//  WeatherAlertTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/25/23.
//

import SwiftUI

struct WeatherAlertTileView: View {
    @Environment(\.colorScheme) var colorScheme
    let weatherAlert: WeatherAlertModel
    
    @State private var showWeatherAlertURL = false
    
    

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.maroon)
                .padding(10)
                .background(Color.lightPink)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(weatherAlert.summary)
                    .bold()
                
                Text("\(weatherAlert.unwrappedRegion) \(weatherAlert.source)")
                .font(.footnote)
                
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color.darkRed)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(Color.lightPink)
        .padding()
        .onTapGesture {
            showWeatherAlertURL = true
        }
        .sheet(isPresented: $showWeatherAlertURL) {
            FullScreenWebView(url: weatherAlert.detailsURL.absoluteString)
                .edgesIgnoringSafeArea(.bottom)
        }      
    }
}

#Preview {
    let holder = WeatherAlertModel(
        detailsURL: URL(string: "https://www.google.com")!,
        region: "Fort Bend",
        severity: .severe,
        source: "National Weather Service",
        summary: "Excessive heat warning"
    )
    WeatherAlertTileView(weatherAlert: holder)
}

