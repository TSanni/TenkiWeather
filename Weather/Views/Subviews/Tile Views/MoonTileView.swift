//
//  MoonTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 10/30/24.
//

import SwiftUI
import WeatherKit

struct MoonTileView: View {
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonPhaseImage: String
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: moonPhaseImage)
                Text(moonPhase)
                    .lineLimit(1)
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            Image(systemName: moonPhaseImage)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()

            HStack {
                Text("Moonrise")
                Spacer()
                Text(moonrise)
            }
            
            Divider()
            
            HStack {
                Text("Moonset")
                Spacer()
                Text(moonset)
            }
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    MoonTileView(
        moonrise: "-",
        moonset: "-",
        moonPhase: "-",
        moonPhaseImage: "-",
        backgroundColor: .brown
    )
}
