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

extension View {
    func settingsFrame() -> some View {
        return self.modifier(SettingsViewFrameViewModifier())
    }
}
