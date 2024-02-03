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
    
    @State private var secondRectangleWidth: CGFloat = 0
    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(color.opacity(0.2))
                .scaledToFit()
                .frame(height: height)
                .background { // use this modifier to get the dimensions of this rectangle and set the state value
                    GeometryReader { geo in
                        Path { path in
                            DispatchQueue.main.async {
                                print("1 frame size = \(geo.size)")
                                secondRectangleWidth = geo.size.width
                            }

                        }
                    }
                }

            Rectangle()
                .fill(color)
                .frame(height: getRectangleHeight() )
                .frame(width: secondRectangleWidth)
                .background {
                    GeometryReader { geo in
                        Path { path in
                            print("2 frame size = \(geo.size)")
                        }
                    }
                }
            
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
        TileImageProgressView(height: 100, value: 50, sfSymbol: "drop.fill", color: Color.orange)
    }
}
