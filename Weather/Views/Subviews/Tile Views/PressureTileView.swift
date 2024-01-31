//
//  PressureTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct PressureTileView: View {
    let pressureDetails: DetailsModel
    let width: CGFloat
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
            
            VStack(alignment: .leading, spacing: 0.0) {
                
                Text(pressureDetails.pressureValue)
                    .font(.largeTitle)
                    .bold()
                
            }
            
            Spacer()
            
            Text(pressureDetails.pressureDescription)
                .font(.footnote)
            
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)

    }
}

#Preview {
    PressureTileView(pressureDetails: DetailsModel.detailsDataHolder, width: 200, backgroundColor: Color.red)
}
