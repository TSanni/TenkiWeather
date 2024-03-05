//
//  HumidityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/5/24.
//

import SwiftUI

struct HumidityTileView: View {
    let humidity: Double
    let dewPointDescription: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "humidity.fill")
                Text("Humidity")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            Spacer()
            
            HStack {
                Text(humidity.formatted(.percent))
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                TileImageProgressView(
                    height: 50,
                    value: humidity * 100,
                    sfSymbol: "humidity.fill",
                    color: K.ColorsConstants.precipitationBlue
                )
            }
            
            Spacer()
            
            Text(dewPointDescription)
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    HumidityTileView(
        humidity: 0.5,
        dewPointDescription: "Dew point description",
        backgroundColor: .red
    )
    .environmentObject(AppStateViewModel.shared)
}
