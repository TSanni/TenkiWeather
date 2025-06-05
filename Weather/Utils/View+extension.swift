//
//  View+extension.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

extension View {
    
    func customNavBackButton(showSearchScreen: Binding<Bool>) -> some View {
        return self.modifier(CustomNavBackButton(showScreen: showSearchScreen))
    }
    
    func settingsListBackgroundChange() -> some View {
        return self.modifier(SettingsListBackgroundViewModifier())
    }
    
    func settingsFrame(colorScheme: ColorScheme) -> some View {
        return self.modifier(SettingsViewFrameViewModifier(colorScheme: colorScheme))
    }
    
    func header() -> some View {
        return self.modifier(HeaderViewModifier())
    }
    
    func subHeader() -> some View {
        return self.modifier(SubHeaderViewModifier())
    }
    
    func cardTileModifier(backgroundColor: Color) -> some View {
        return self.modifier(CardViewModifier(backgroundColor: backgroundColor))
    }
    
    func bigCardTileModifier(backgroundColor: Color) -> some View {
        return self.modifier(BigCardViewModifier(backgroundColor: backgroundColor))
    }
    
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}
