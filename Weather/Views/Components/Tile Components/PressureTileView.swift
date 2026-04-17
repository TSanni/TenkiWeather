//
//  PressureTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct PressureTileView: View {
    let pressureString: String
    let pressureValue: Double
    let pressureDescription: String
    let backgroundColor: Color
    let inchesOfMercuryPressureValue: Double
    
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
                Text(pressureString)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                CircularProgressView(pressure: inchesOfMercuryPressureValue)
                    .frame(width: 80)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            Spacer()
            
            Text(pressureDescription)
                .font(.subheadline)
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    let todayWeatherModelPlaceHolder = TodayWeatherModelPlaceHolder.holderData
    
    PressureTileView(
        pressureString: todayWeatherModelPlaceHolder.pressureString,
        pressureValue: todayWeatherModelPlaceHolder.pressureValue,
        pressureDescription: todayWeatherModelPlaceHolder.pressureDescription,
        backgroundColor: Color.brown,
        inchesOfMercuryPressureValue: 25
    )
    .frame(width: 250)
    .environmentObject(AppStateViewModel.preview)
}
