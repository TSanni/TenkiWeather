//
//  SubHeaderViewModifier+ViewModifier.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/22/24.
//

import Foundation
import SwiftUI

struct SubHeaderViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
}
