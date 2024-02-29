//
//  SettingsListBackgroundViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

struct SettingsListBackgroundViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        let darkTheme = K.ColorsConstants.goodDarkTheme.clipShape(RoundedRectangle(cornerRadius: 10))
        let lightTheme = K.ColorsConstants.goodLightTheme.clipShape(RoundedRectangle(cornerRadius: 10))
        
        content
            .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
            .listRowSeparator(.hidden)
        
    }
}
