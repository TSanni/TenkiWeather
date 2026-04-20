//
//  CustomDivider.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct CustomDivider: View {
    let color: Color
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 0.5)
    }
}

#Preview {
    CustomDivider(color: Color.primary)
}
