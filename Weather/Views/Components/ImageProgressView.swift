//
//  ImageProgressView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/17/24.
//

import SwiftUI

struct ImageProgressView: View {
     let height: CGFloat
     let value: CGFloat
     let sfSymbol: String
     let color: Color
     var maxValue: Double? = 100
     
     @State private var secondRectangleWidth: CGFloat = 0
     var body: some View {
         
         
         ZStack(alignment: .bottom) {
             Rectangle()
                 .fill(color.opacity(0.4))
                 .scaledToFit()
                 .frame(height: height)
                 .background { // use this modifier to get the dimensions of this rectangle and set the state value
                     GeometryReader { geo in
                         Path { path in
                             DispatchQueue.main.async {
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
        ImageProgressView(height: 25, value: 50, sfSymbol: "drop.fill", color: Color.orange)
    }
}
