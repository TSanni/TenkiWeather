//
//  VisibilityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct VisibilityTileView: View {
    let visibilityDetails: TodayWeatherModel
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "eye.fill")
                Text("Visibility")
                Spacer()
            }
            .foregroundStyle(.secondary)

            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0.0) {
                
                Text(visibilityDetails.visibilityValue)
                    .font(.largeTitle)
                    .bold()
                
                
            }
            
            Spacer()
            
            Text(visibilityDetails.visiblityDescription)
                .font(.footnote)
            
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
        
    }
}

#Preview {
    VisibilityTileView(
        visibilityDetails: TodayWeatherModel.holderData,
        backgroundColor: Color(uiColor: K.Colors.haze)
    )
    .frame(width: 250)
}
