//
//  SunsetSunriseView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI

struct SunsetSunriseView: View {
    @Environment(\.colorScheme) var colorScheme
    let sunData: SunData
    let dayLight: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Sunrise & Sunset")
                .bold()
                .padding(.vertical)
            
            HStack {
                VStack(spacing: 5.0) {
                    Text("Sunrise").foregroundColor(.secondary)
                    Text(sunData.sunrise).font(.title)
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Sunset").foregroundColor(.secondary)
                    Text(sunData.sunset).font(.title)
                }
            }
            
            HStack {
                Spacer()
                Image(systemName: "sunrise.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color(uiColor: K.Colors.properBlack), .yellow)
                    .frame(height: 100)
                Spacer()
                Spacer()
                Image(systemName: "sunset.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color(uiColor: K.Colors.properBlack), .orange)
                    .frame(height: 100)
                Spacer()
            }
            
            HStack {
                VStack(spacing: 5.0) {
                    Text("Dawn").foregroundColor(.secondary)
                    Text(sunData.dawn)
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Solar noon").foregroundColor(.secondary)
                    Text(sunData.solarNoon)
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Dusk").foregroundColor(.secondary)
                    Text(sunData.dusk)
                }
                
            }
            
            VStack(alignment: .leading, spacing: 10.0) {
                HStack {
                    if dayLight {
                        Text("There is currently daylight")
                            .font(.subheadline)
                            .bold()
                    } else {
                        Text("There is currently no daylight")
                            .font(.subheadline)
                            .bold()
                    }
                    
                    // Possibly add length of day if Apple updates WeatherKit
//                    Text("Length of day").foregroundColor(.secondary)
//                    Text("17h 77m")
                }
                .padding()
                
                // Possibly add remaining daylight if Apple updates WeatherKit
//                HStack {
//                    Text("Remaining daylight").foregroundColor(.secondary)
//                    Text("17h 77m")
//                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .padding(.bottom)
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

    }
}

struct SunsetSunriseView_Previews: PreviewProvider {
    static var previews: some View {
        SunsetSunriseView(sunData: SunData.sunDataHolder, dayLight: true)
    }
}
