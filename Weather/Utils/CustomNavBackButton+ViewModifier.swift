//
//  CustomNavBackButton+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

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
