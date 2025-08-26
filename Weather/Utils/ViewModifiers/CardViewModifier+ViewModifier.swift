//
//  CardViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

struct CardViewModifier: ViewModifier {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding()
            .background(appStateViewModel.blendColorWith20PercentWhite(themeColor: backgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black, radius: 0, y: 0.5)
            .shadow(radius: 3)
    }
}

