//
//  DistanceAndSpeedSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct DistanceAndSpeedSection: View {
    @AppStorage(K.UserDefaultKeys.unitDistanceKey) var distanceUnit: DistanceUnits = .miles

    var body: some View {
        Section("Distance and Speed") {
            ForEach(DistanceUnits.allCases, id: \.title) { unit in
                HStack {
                    Text(unit.title.capitalized)
                        .foregroundStyle(.primary)
                    Group {
                        Text("(" + unit.distanceSymbol)
                        Text(unit.speedSymbol + ")")
                    }
                    .foregroundStyle(.secondary)

                    Spacer()
                    if distanceUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    distanceUnit = unit
                }
            }
        }
    }
}

#Preview {
    DistanceAndSpeedSection()
}
