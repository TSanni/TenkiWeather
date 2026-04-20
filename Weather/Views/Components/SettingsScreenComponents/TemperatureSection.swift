//
//  TemperatureSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct TemperatureSection: View {
    @AppStorage(K.UserDefaultKeys.unitTemperatureKey) var temperatureUnit: TemperatureUnits = .fahrenheit
    @AppStorage(K.UserDefaultKeys.showTemperatureUnitKey) var showTemperatureUnit: Bool = false

    var body: some View {
        Section("Temperature") {
            ForEach(TemperatureUnits.allCases, id: \.title) { unit in
                HStack {
                    Text(unit.title.capitalized)
                        .foregroundStyle(.primary)
                    Text("(" + unit.symbol + ")")
                        .foregroundStyle(.secondary)
                    Spacer()
                    if temperatureUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    temperatureUnit = unit
                }
            }
            
            Toggle(isOn: $showTemperatureUnit) {
                Text("Show unit")
            }
        }
    }
}

#Preview {
    TemperatureSection()
}
