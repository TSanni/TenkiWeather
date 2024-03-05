//
//  PrecipitationTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct PrecipitationTileView: View {
    let precipiation: Double
    let precipitationDescription: String
    let precipitationFooter: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "drop.fill")
                Text("Precipitation")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 0.0) {
                    
                    Text(precipiation.formatted(.percent))
                        .font(.largeTitle)
                        .bold()
                    
                    Text(precipitationDescription.capitalized)
                        .font(.title3)
                        .bold()
                }
                
                Spacer()
                
                TileImageProgressView(
                    height: 50, 
                    value: precipiation * 100,
                    sfSymbol: "drop.fill",
                    color: K.ColorsConstants.precipitationBlue
                )
                .aspectRatio(1, contentMode: .fit)
            }
            
            Spacer()
            
            Text(precipitationFooter)
                .font(.subheadline)
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    PrecipitationTileView(
        precipiation: 0.5,
        precipitationDescription: "Hail", 
        precipitationFooter: "200% Chance of precipitation",
        backgroundColor: .red
    )
    .frame(width: 200)
    .environmentObject(AppStateViewModel.shared)
}
