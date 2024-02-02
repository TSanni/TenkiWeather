//
//  UVIndexTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct UVIndexTileView: View {
    let uvIndexDetails: DetailsModel
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
                    Text(uvIndexDetails.uvIndexValueDescription)
                        .font(.largeTitle)
                        .bold()
                    Text(uvIndexDetails.uvIndexCategoryDescription)
                        .bold()
                }
                
                Spacer()
                
                TileImageProgressView(
                    height: 50,
                    value: CGFloat(uvIndexDetails.uvIndexValue),
                    sfSymbol: "seal.fill",
                    color: uvIndexDetails.uvIndexColor,
                    maxValue: 11
                )
                .aspectRatio(1, contentMode: .fit)

            }
       
                Spacer()
                
                Text(uvIndexDetails.uvIndexActionRecommendation)
                    .font(.footnote)
                      
        }
        .cardTileModifier(backgroundColor: backgroundColor)
        
    }
}


#Preview {
    UVIndexTileView(uvIndexDetails: DetailsModel.detailsDataHolder, backgroundColor: Color(uiColor: K.Colors.haze))
        .frame(width: 200)
}
