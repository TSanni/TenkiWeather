//
//  PrecipitationTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI
import WeatherKit

struct PrecipitationTileView: View {
    let precipitation: Precipitation
    let precipiationChance: Double
    let precipitationDescription: String
    let precipitationFooter: String
    let backgroundColor: Color
    
    var tileImage: String {
        switch precipitation {
        case .none:
            return "drop.fill"
        case .hail:
            return "cloud.hail.fill"
        case .mixed:
            return "snowflake"
        case .rain:
            return "drop.fill"
        case .sleet:
            return "cloud.sleet.fill"
        case .snow:
            return "snowflake"
        @unknown default:
            return "drop.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: tileImage)
                Text("Precipitation")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 0.0) {
                    
                    Text(precipiationChance.formatted(.percent))
                        .font(.largeTitle)
                        .bold()
                    
                    Text(precipitationDescription.capitalized)
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                ImageProgressView(
                    height: 50, 
                    value: precipiationChance * 100,
                    sfSymbol: tileImage,
                    color: Color.precipitationBlue
                )
                .aspectRatio(1, contentMode: .fit)
            }
            
            Spacer()
            
            Text(precipitationFooter)
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    PrecipitationTileView(
        precipitation: .hail,
        precipiationChance: 0.5,
        precipitationDescription: "Hail",
        precipitationFooter: "200% Chance of precipitation",
        backgroundColor: .red
    )
    .frame(width: 200)
    .environmentObject(AppStateViewModel.preview)
}
