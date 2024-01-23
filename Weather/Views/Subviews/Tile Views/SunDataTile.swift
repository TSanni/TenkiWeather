//
//  SunDataTile.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/23/24.
//

import SwiftUI

struct SunDataTile: View {
    let sundata: SunData
    let backgroundColor: Color
    let isSunrise: Bool
    let width: CGFloat
    
    
    var sunrise: some View {
        VStack(alignment: .leading) {

            HStack {
                Image(systemName: "sunrise")
                Text("Sunrise")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(sundata.sunrise)
                .font(.largeTitle)
            
            Spacer()

            Text("Dawn: \(sundata.dawn)")
 
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .aspectRatio(1, contentMode: .fit)
        .frame(width: width)
        .foregroundStyle(.white)
    }
    
    var sunset: some View {
        VStack(alignment: .leading) {

            HStack {
                Image(systemName: "sunset")
                Text("Sunset")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(sundata.sunset)
                .font(.largeTitle)
            
            Spacer()

            Text("Dusk: \(sundata.dusk)")
 
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .aspectRatio(1, contentMode: .fit)
        .frame(width: width)
        .foregroundStyle(.white)
    }
    
    
    var body: some View {
        Group {
            if isSunrise {
                sunrise
            } else {
                sunset
            }
        }
       

    }
}

#Preview {
    SunDataTile(sundata: SunData.sunDataHolder, backgroundColor: TodayWeatherModel.holderData.backgroundColor, isSunrise: true, width: 200)
}
