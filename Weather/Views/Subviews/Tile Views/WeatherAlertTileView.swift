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
                .foregroundColor(Color(uiColor: K.Colors.maroon))
//                .foregroundColor(weatherAlert.severityColor)

                .font(.title)
                .padding()
                .background(Color(uiColor: K.Colors.lightPink))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(weatherAlert.summary)
                    .bold()
                HStack(spacing: 0) {
                    if weatherAlert.region != "" {
                        Text("\(weatherAlert.region) • ")
                    }
                    Text("\(weatherAlert.source) ")

                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color(uiColor: K.Colors.darkRed))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(Color(uiColor: K.Colors.lightPink))
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
            .previewDevice("iPhone 11 Pro Max")
    }
}







/*
 
 var oldAlertView: some View {
     VStack(alignment: .leading, spacing: 10.0) {
         HStack {
             Image(systemName: "exclamationmark.triangle.fill")
                 .foregroundColor(weatherAlert.severityColor)
             
             Text("\(weatherAlert.summary)")
                 .font(.title)
                 .lineLimit(1)
                 .minimumScaleFactor(0.5)
                 .foregroundColor(.primary)
                 .bold()
         }

         HStack(spacing: 0) {
             Text("\(weatherAlert.source) ")
                 .lineLimit(1)
                 .minimumScaleFactor(0.7)
             
             if weatherAlert.region != "" {
                 Text("• \(weatherAlert.region)")
                     .lineLimit(1)
                     .minimumScaleFactor(0.7)
             }
         }
         .foregroundColor(.secondary)

         HStack(spacing: 0) {
             Text("More Info")
                 .foregroundColor(.primary)
             
             Text(" →")
                 .foregroundColor(.secondary)
         }
         .padding([.vertical])
         .onTapGesture {
             showWeatherAlertURL = true
         }
     }
     .padding()
     .frame(maxWidth: .infinity, alignment: .leading)
     .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)
     .fullScreenCover(isPresented: $showWeatherAlertURL) {
         FullScreenWebView(url: weatherAlert.detailsURL.absoluteString)
             .edgesIgnoringSafeArea(.bottom)

     }

 }

 
 
 */
