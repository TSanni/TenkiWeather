//
//  CustomNavBackButton.swift
//  MercariClone
//
//  Created by Tomas Sanni on 1/26/23.
//

import SwiftUI


//MARK: - Add this view modifier to any view that requires a custom back button
struct CustomNavBackButton: ViewModifier {
    @Binding var showSearchScreen: Bool

//    init(test: Binding<Bool>) {
//
//    }
    
    
    @Environment(\.dismiss) var dismiss
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            showSearchScreen = false
                        }
                        
//                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.secondary)
                            .contentShape(Rectangle())
                    }

                }
            }
        
    }
}

extension View {
    
    func customNavBackButton(showSearchScreen: Binding<Bool>) -> some View {
        return self.modifier(CustomNavBackButton(showSearchScreen: showSearchScreen))
    }
}


