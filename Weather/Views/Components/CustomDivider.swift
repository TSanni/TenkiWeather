//
//  CustomDivider.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary)
            .frame(height: 0.5)
    }
}

#Preview {
    CustomDivider()
}
