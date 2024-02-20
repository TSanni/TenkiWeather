//
//  UVIndexTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct UVIndexTileView: View {
    let uvIndexNumberDescription: String
    let uvIndexCategoryDescription: String
    let uvIndexValue: Int
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
                    Text(uvIndexNumberDescription)
                        .font(.largeTitle)
                        .bold()
                    Text(uvIndexCategoryDescription)
                        .bold()
                }
                
                Spacer()
                
                TileImageProgressView(
                    height: 50,
                    value: CGFloat(uvIndexValue),
                    sfSymbol: "seal.fill",
                    color: uvIndexColor,
                    maxValue: 11
                )

            }
       
                Spacer()
                
                Text(uvIndexActionRecommendation)
                    .font(.footnote)
                      
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}


#Preview {
    UVIndexTileView(
        uvIndexNumberDescription: "",
        uvIndexCategoryDescription: "",
        uvIndexValue: 9, uvIndexColor: .red,
        uvIndexActionRecommendation: "",
        backgroundColor: .red
    )
        .frame(width: 200)
}
