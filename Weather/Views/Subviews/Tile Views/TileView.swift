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
    let staticImageName: String?
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    if let valueDescription = valueDescription {
                        Text(valueDescription)
                            .bold()
                            .font(.body)
                    }
                }
                
                Spacer()
                
                if let dynamicImage = dynamicImage {
                    dynamicImage
                } else if let staticImage = staticImageName {
                    Image(systemName: staticImage)
                        .renderingMode(.original)
                }
                
            }
            .font(.largeTitle)
            
            Spacer()
            
            Text(footer)
                .font(.subheadline)
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
            staticImageName: "cloud",
            footer: "Use sunscreen always",
            backgroundColor: Color.red
        )
        .environmentObject(AppStateManager.shared)
    }
}
