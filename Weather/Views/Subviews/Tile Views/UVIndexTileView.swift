//
//  UVIndexTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/5/24.
//

import SwiftUI

struct UVIndexTileView: View {
    let uvIndexNumber: Int
    let uvIndexDescription: String
    let uvIndexColor: Color
    let uvIndexActionRecommendation: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "sun.max.fill")
                Text("UV Index")
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(uvIndexNumber.description)
                        .font(.largeTitle)
                        .bold()
                    Text(uvIndexDescription)
                        .bold()
                }
                
                Spacer()
                
                TileImageProgressView(
                    height: 50,
                    value: CGFloat(uvIndexNumber),
                    sfSymbol: "seal.fill",
                    color: uvIndexColor,
                    maxValue: 11
                )
                
            }
            
            Spacer()
            
            Text(uvIndexActionRecommendation)
            
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    UVIndexTileView(
        uvIndexNumber: 5,
        uvIndexDescription: "UV Description",
        uvIndexColor: .orange,
        uvIndexActionRecommendation: "Recommendation",
        backgroundColor: .indigo
    )
    .environmentObject(AppStateViewModel.shared)
}
