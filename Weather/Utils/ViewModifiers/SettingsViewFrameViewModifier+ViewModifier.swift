//
//  SettingsViewFrameViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

struct SettingsViewFrameViewModifier: ViewModifier {
    let colorScheme: ColorScheme
    func body(content: Content) -> some View {
        content
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 500 : nil)
            .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 300)
            .foregroundStyle(.primary)
            .padding()
            .background(colorScheme == .light ? .white : Color.goodDarkTheme)
            .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
    }
}
