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
                .foregroundColor(Color(uiColor: K.ColorsConstants.maroon))
                .padding(10)
                .background(Color(uiColor: K.ColorsConstants.lightPink))
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
        .background(Color(uiColor: K.ColorsConstants.darkRed))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(Color(uiColor: K.ColorsConstants.lightPink))
        .padding()
        .onTapGesture {
            showWeatherAlertURL = true
        }
        .fullScreenCover(isPresented: $showWeatherAlertURL) {
            FullScreenWebView(url: weatherAlert.detailsURL.absoluteString)
                .edgesIgnoringSafeArea(.bottom)

        }
        
        
    }
}

struct WeatherAlertView_Previews: PreviewProvider {
    static var previews: some View {
        
        let holder = WeatherAlertModel(detailsURL: URL(string: "https://www.google.com")!, region: "Fort Bend", severity: .severe, source: "National Weather Service", summary: "Excessive heat warning")
        WeatherAlertTileView(weatherAlert: holder)
    }
}

