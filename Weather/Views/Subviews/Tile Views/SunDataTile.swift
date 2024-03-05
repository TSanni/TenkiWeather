//
//  SunDataTile.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/5/24.
//

import SwiftUI

struct SunDataTile: View {
    let sundata: SunData
    let backgroundColor: Color
    let isSunrise: Bool
    
    
    var sunrise: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "sunrise")
                Text("Sunrise")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                Text(sundata.sunriseTime)
                    .font(.largeTitle)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                Image(systemName: "sunrise.fill")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55)
            }
            
            Spacer()
            
            Text(sundata.dawnDescription)
            
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
        
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
            
            HStack {
                Text(sundata.sunsetTime)
                    .font(.largeTitle)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                Image(systemName: "sunset.fill")
                    .resizable()
                    .foregroundStyle(.white, .orange)
                    .scaledToFit()
                    .frame(width: 55)
            }
            
            Spacer()
            
            Text(sundata.duskDescription)
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
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
    SunDataTile(sundata: SunData.sunDataHolder, backgroundColor: .red, isSunrise: false)
        .environmentObject(AppStateViewModel.shared)
}
