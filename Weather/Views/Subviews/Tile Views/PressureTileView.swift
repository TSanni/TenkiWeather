//
//  PressureTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct PressureTileView: View {
    let pressureDetails: TodayWeatherModel
    let backgroundColor: Color
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                Text("Pressure")
                Spacer()
            }
            .foregroundStyle(.secondary)

            
            Spacer()
            
            HStack {
                
                Text(pressureDetails.pressureString)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                CircularProgressView(pressure: pressureDetails.pressureValue)
                    .frame(width: 80)
                    .aspectRatio(1, contentMode: .fit)
                
                
            }
            
            Spacer()
            
            Text(pressureDetails.pressureDescription)
                .font(.footnote)
            
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)

    }
}

#Preview {
    PressureTileView(pressureDetails: TodayWeatherModel.holderData, backgroundColor: Color.brown)
        .frame(width: 250)
        .environmentObject(AppStateManager())
}
