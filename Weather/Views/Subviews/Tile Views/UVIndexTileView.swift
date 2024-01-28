//
//  UVIndexTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct UVIndexTileView: View {
    let uvIndexDetails: DetailsModel
    let width: CGFloat
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
            
//            VStack(alignment: .leading, spacing: 0.0) {
                
                Text(uvIndexDetails.uvIndexValueDescription)
                    .font(.largeTitle)
                    .bold()
                
                Text(uvIndexDetails.uvIndexCategoryDescription)
//                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Text(uvIndexDetails.uvIndexActionRecommendation)
                    .font(.footnote)
                    
//            }
  
        }
        .cardTileModifier(backgroundColor: backgroundColor, width: width)
    }
}


#Preview {
    UVIndexTileView(uvIndexDetails: DetailsModel.detailsDataHolder, width: 170, backgroundColor: Color.red)
}
