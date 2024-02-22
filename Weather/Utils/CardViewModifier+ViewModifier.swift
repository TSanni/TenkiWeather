//
//  CardViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

struct CardViewModifier: ViewModifier {
    @EnvironmentObject var appStateManager: AppStateManager
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: K.tileCornerRadius)
                        .stroke(lineWidth: 0.5)
                        .fill(.white)
                    RoundedRectangle(cornerRadius: K.tileCornerRadius).fill(appStateManager.blendColorWithTwentyPercentWhite(themeColor: backgroundColor))
                }
            }
            .aspectRatio(1, contentMode: .fit)
    }
}

