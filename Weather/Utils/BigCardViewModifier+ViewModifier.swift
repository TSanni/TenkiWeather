//
//  BigCardViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 10/28/24.
//

import Foundation
import SwiftUI

struct BigCardViewModifier: ViewModifier {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.white)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
            .padding()
            .shadow(color: .black, radius: 0, y: 0.5)
            .shadow(radius: 3)
    }
}

