//
//  SupportSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct SupportSection: View {
    var body: some View {
        Section("Support") {
            SendMailView()
        }
    }
}

#Preview {
    SupportSection()
}
