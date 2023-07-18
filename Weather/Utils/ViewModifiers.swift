//
//  SettingsViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/16/23.
//

import Foundation
import SwiftUI

struct SettingsViewFrameViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 500 : nil)
            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 300)
    }
}



struct SettingsListBackgroundViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        let darkTheme = K.Colors.goodDarkTheme.clipShape(RoundedRectangle(cornerRadius: 10))
        let lightTheme = K.Colors.goodLightTheme.clipShape(RoundedRectangle(cornerRadius: 10))
        
        content
            .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
            .listRowSeparator(.hidden)
        
    }
}

extension View {
    func settingsListBackgroundChange() -> some View {
        return self.modifier(SettingsListBackgroundViewModifier())
    }
    
    func settingsFrame() -> some View {
        return self.modifier(SettingsViewFrameViewModifier())
    }
    
}

