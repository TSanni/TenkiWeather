//
//  HumidityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct HumidityTileView: View {
    let humidity: Double
    let humidityPercentage: String
    let dewPointDescription: String
    let backgroundColor: Color

    ///The humidity passed in is a value 0-1 representing a percentage.
    ///This function multiplies that value by 100 to get a regular number
    ///Ex) 0.2 will return 20
    func convertHumidityFromPercentToDouble(humidity: Double) -> Double {
        let newHumidity = humidity * 100
        return newHumidity
    }
    
    var body: some View {
        let humidity = convertHumidityFromPercentToDouble(humidity: humidity)
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "humidity.fill")
                Text("Humidity")
                Spacer()
            }
            .foregroundStyle(.secondary)

            Spacer()
            
            HStack {
                Text(humidityPercentage)
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                TileImageProgressView(
                    height: 50,
                    value: humidity,
                    sfSymbol: "humidity.fill",
                    color: K.Colors.precipitationBlue
                )
            }
            
            Spacer()
            
            Text("The dew point is " + dewPointDescription + " right now.")
                .font(.footnote)

        }
        .cardTileModifier(backgroundColor: backgroundColor)

    }
}

#Preview {
    HumidityTileView(
        humidity: 0.5,
        humidityPercentage: "50%",
        dewPointDescription: "",
        backgroundColor: Color(uiColor: K.Colors.haze)
    )
    .frame(width: 200)
    .environmentObject(AppStateManager.shared)
    
}
