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
    let backgroundColor: Color
    
    
    ///The humidity passed in is a value 0-1 representing a percentage.
    ///This function multiplies that value by 100 to get a regular number
    ///Ex) 0.2 will return 20
    func convertPrecipitationFromPercentToDouble(precipitation: Double) -> CGFloat {
        let newPrecipitation = precipitation * 100
        return newPrecipitation
    }
    
    
    var body: some View {
//        let precipitation = convertPrecipitationFromPercentToDouble(precipitation: precipiation)
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
                    imageHeight: precipiation * 100,
                    sfSymbol: "drop.fill",
                    color: K.Colors.precipitationBlue
                )
                .aspectRatio(1, contentMode: .fit)
            }
            
            
            Spacer()
            
            Text(precipiation.formatted(.percent) + " chance of precipitation")
                .font(.footnote)

            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }

}

#Preview {
    PrecipitationTileView(
        precipiation: 0.5,
        precipitationDescription: "",
        backgroundColor: .red
    )
    .frame(width: 200)
    .environmentObject(AppStateManager.shared)
}
