//
//  HumidityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct HumidityTileView: View {
    let humidityDetails: DetailsModel
    let width: CGFloat
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
            
            Text(humidityDetails.humidityPercentage)
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            Text("The dew point is \(humidityDetails.dewPointDescription) right now.")
                .font(.footnote)

            
        }
        .cardTileModifier(backgroundColor: backgroundColor)

    }
}

#Preview {
    HumidityTileView(humidityDetails: DetailsModel.detailsDataHolder, width: 200, backgroundColor: Color.red)
}
