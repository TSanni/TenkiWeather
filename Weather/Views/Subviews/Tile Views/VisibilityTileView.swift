//
//  VisibilityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/24/24.
//

import SwiftUI

struct VisibilityTileView: View {
    let visibilityDetails: DetailsModel
    let width: CGFloat
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
                
                Text(visibilityDetails.visibility ?? "")
                    .font(.largeTitle)
                    .bold()
                
                
            }
            
            Spacer()
            
            Text(visibilityDetails.visiblityDescription)
                .font(.footnote)
            
            
        }
        .cardTileModifier(backgroundColor: backgroundColor, width: width)
        
    }
}

#Preview {
    VisibilityTileView(visibilityDetails: DetailsModel.detailsDataHolder, width: 200, backgroundColor: Color.red)
}
