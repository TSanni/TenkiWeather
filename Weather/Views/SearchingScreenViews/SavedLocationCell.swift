//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    @ObservedObject var location: LocationEntity
    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
    @State private var showAlert = false
    @State private var textFieldText = ""
    var body: some View {
        ZStack {
            Color.teal.opacity(0.000001)
            
            HStack {
                SavedLocationImageView(imageName: location.sfSymbol ?? "")
                
                VStack(alignment: .leading) {
                    Text(location.name ?? "no name")
                        .font(.headline)
//                        .onTapGesture {
//                            persistence.updatePlace(entity: location)
//                        }
                    
                    HStack(alignment: .top, spacing: 0.0) {
                        Text((newTemp) + "°")
                        Text(" • ")
                        Text(location.weatherCondition ?? "")
                    }
                    .font(.subheadline)
                }
                
                if location.weatherAlert {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.white)
        .contextMenu {
            RenameButton()
            Button(role: .destructive) {
                persistence.deleteLocationFromContextMenu(entity: location)
            } label: {
                Text("Delete")
            }

        }
        .renameAction {
            showAlert.toggle()
        }
        .alert("Rename", isPresented: $showAlert) {
            TextField("New name", text: $textFieldText)
            Button("OK") {
                persistence.updatePlaceName(entity: location, newName: textFieldText)
            }
            
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }

        }
    }
    
    
    var newTemp: String {
        let oldTemp = location.temperature ?? "0"
        let oldTempToDouble = Double(oldTemp) ?? 0
        let oldTempUnit = location.unitTemperature ?? .fahrenheit
        let oldTempToMeasurement = Measurement(value: oldTempToDouble, unit: oldTempUnit)
        let newTemp = oldTempToMeasurement.converted(to: Helper.getUnitTemperature())
        let newTempWithNoFloatingNumbers = String(format: "%.0f", newTemp.value)
        return newTempWithNoFloatingNumbers
    }
}

//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(location: TodayWeatherModel.holderData)
//    }
//}
