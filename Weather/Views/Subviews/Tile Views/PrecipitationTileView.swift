//
//  PrecipitationTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct PrecipitationTileView: View {
    let precipitationDetails: TomorrowWeatherModel
    let width: CGFloat
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
            
            VStack(alignment: .leading, spacing: 0.0) {
                
                Text(precipitationDetails.tomorrowChanceOfPrecipitation)
                    .font(.largeTitle)
                    .bold()
                
                Text(precipitationDetails.precipitation.description.capitalized)
                    .font(.title3)
                    .bold()
            }
            
            
            Spacer()
            
            Text("\(precipitationDetails.tomorrowChanceOfPrecipitation) chance of precipitation.")
                .font(.footnote)

            
        }
        .cardTileModifier(backgroundColor: backgroundColor, width: width)
    }

}

#Preview {
    PrecipitationTileView(precipitationDetails: TomorrowWeatherModel.tomorrowDataHolder, width: 200, backgroundColor: Color.red)
}
