//
//  PrecipitationSection.swift
//  Weather
//
//  Created by Tomas Sanni on 4/18/26.
//
import SwiftUI

struct PrecipitationSection: View {
    @AppStorage(K.UserDefaultKeys.unitLengthKey) var lengthUnit: LengthUnits = .inches

    var body: some View {
        Section("Precipitation") {
            ForEach(LengthUnits.allCases, id: \.title) { unit in
                HStack {
                    Text(unit.title.capitalized)
                        .foregroundStyle(.primary)
                    Text("(" + unit.symbol + ")")
                        .foregroundStyle(.secondary)
                    Spacer()
                    if lengthUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    lengthUnit = unit
                }
            }
        }
    }
}
