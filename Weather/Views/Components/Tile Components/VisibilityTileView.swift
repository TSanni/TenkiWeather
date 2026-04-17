//
//  VisibilityTileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/5/24.
//

import SwiftUI

struct VisibilityTileView: View {
    let visibilityValue: String
    let visiblityDescription: String
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
                
                Text(visibilityValue)
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer()
            
            Text(visiblityDescription)
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    VisibilityTileView(
        visibilityValue: "70",
        visiblityDescription: "Description",
        backgroundColor: .red
    )
    .environmentObject(AppStateViewModel.preview)
}
