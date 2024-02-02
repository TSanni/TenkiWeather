//
//  TileImageProgressView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/1/24.
//

import SwiftUI

struct TileImageProgressView: View {
    
    let height: CGFloat
    let value: CGFloat
    let sfSymbol: String
    let color: Color
    var maxValue: Double? = 100
    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.5))
                .frame(height: height)

            Rectangle().fill(color)
                .frame(height: getRectangleHeight() )
        }
        .mask {
            Image(systemName: sfSymbol)
                .resizable()
                .scaledToFit()
        } 
    }
    
    private func getRectangleHeight() -> CGFloat {
        let converted = height * (value / (maxValue ?? 100))
        return converted
    }
    
    
}


#Preview {
    ZStack {
        Color.brown
        TileImageProgressView(height: 100, value: 50, sfSymbol: "drop.fill", color: Color.blue)
    }
}
