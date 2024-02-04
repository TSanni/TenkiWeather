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


struct HeaderViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .padding()
    }
}


struct SubHeaderViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
}

//MARK: - Add this view modifier to any view that requires a custom back button
struct CustomNavBackButton: ViewModifier {
    @Binding var showScreen: Bool

    
    
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            showScreen = false
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.secondary)
                            .contentShape(Rectangle())
                    }

                }
            }
    }
}


struct CardViewModifier: ViewModifier {
    @EnvironmentObject var appStateManager: AppStateManager
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding()
            .background(appStateManager.blendColorWithTwentyPercentWhite(themeColor: backgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
            .aspectRatio(1, contentMode: .fit)
    }
}




extension View {
    
    func customNavBackButton(showSearchScreen: Binding<Bool>) -> some View {
        return self.modifier(CustomNavBackButton(showScreen: showSearchScreen))
    }
    
    func settingsListBackgroundChange() -> some View {
        return self.modifier(SettingsListBackgroundViewModifier())
    }
    
    func settingsFrame() -> some View {
        return self.modifier(SettingsViewFrameViewModifier())
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
}

