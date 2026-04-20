//
//  PressureSection.swift
//  Weather
//
//  Created by Tomas Sanni on 4/18/26.
//
import SwiftUI

struct PressureSection: View {
    @AppStorage(K.UserDefaultKeys.unitPressureKey) var pressureUnit: PressureUnits = .inchesOfMercury

    var body: some View {
        Section("Pressure") {
            ForEach(PressureUnits.allCases, id: \.title) { unit in
                HStack {
                    Text(unit.titleForUI.capitalized)
                        .foregroundStyle(.primary)
                    Text("(" + unit.symbol + ")")
                        .foregroundStyle(.secondary)
                    Spacer()
                    if pressureUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    pressureUnit = unit
                }
            }
        }
    }
}
