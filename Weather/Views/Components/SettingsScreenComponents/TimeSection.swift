//
//  TimeSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct TimeSection: View {
    @AppStorage(K.UserDefaultKeys.timePreferenceKey) var toggle24HourTime: Bool = false

    var body: some View {
        Section("Time") {
            Toggle(isOn: $toggle24HourTime) {
                Text("Use 24-hour format")
            }
        }
    }
}

#Preview {
    TimeSection()
}
