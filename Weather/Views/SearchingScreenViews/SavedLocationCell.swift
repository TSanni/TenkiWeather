//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    @ObservedObject var location: LocationEntity
    
    var body: some View {
        ZStack {
            Color.teal.opacity(0.000001)
            HStack {
                SavedLocationImageView(imageName: location.sfSymbol ?? "")
                
                VStack(alignment: .leading) {
                    Text(location.name ?? "no name")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 0.0) {
                        Text((newTemp) + "°")
                        Text(" • ")
                        Text(location.weatherCondition ?? "")
                    }
                    .font(.subheadline)
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
    
    
    var newTemp: String {
        let oldTemp = location.temperature ?? "0"
        let oldTempToDouble = Double(oldTemp) ?? 0
        let oldTempUnit = location.unitTemperature ?? .fahrenheit
        print("the unit temp: \(oldTempUnit)")
        let oldTempToMeasurement = Measurement(value: oldTempToDouble, unit: oldTempUnit)
        
        let newTemp = oldTempToMeasurement.converted(to: Helper.getUnitTemperature())
        let removeFloatingPointsFromNewTemp = String(format: "%.0f", newTemp.value)
        return removeFloatingPointsFromNewTemp
    }
}

//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(location: TodayWeatherModel.holderData)
//    }
//}
