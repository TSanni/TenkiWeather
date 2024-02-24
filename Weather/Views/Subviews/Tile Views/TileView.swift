//
//  TileView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/23/24.
//

import SwiftUI

struct TileView: View {
    let imageHeader: String
    let title: String
    let value: String
    let valueDescription: String?
    let dynamicImage: TileImageProgressView?
    let footer: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: imageHeader)
                Text(title)
            }
            .font(.headline)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(value)
                        .bold()
                    
                    if let valueDescription = valueDescription {
                        Text(valueDescription)
                            .bold()
                            .font(.body)
                    }
                }
                
                Spacer()
                if let dynamicImage = dynamicImage {
                    dynamicImage
                }
            }
            .font(.largeTitle)
            
            Spacer()
            
            Text(footer)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .cardTileModifier(backgroundColor: backgroundColor)
    }
}

#Preview {
    ZStack {
        Color.brown.ignoresSafeArea()
        TileView(
            imageHeader: "sun.max",
            title: "Sun example card",
            value: "50", 
            valueDescription: "Extreme",
            dynamicImage:  TileImageProgressView(height: 30, value: 50, sfSymbol: "drop.fill", color: .green),
            footer: "Use sunscreen always", 
            backgroundColor: Color.red
        )
        .environmentObject(AppStateManager.shared)
    }
}
