//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    @ObservedObject var location: Location
    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @State private var showAlert = false
    @State private var textFieldText = ""
    @State private var time = ""
    
    var body: some View {
        
        HStack {
            SavedLocationImageView(imageName: location.sfSymbol ?? "")
            
            VStack(alignment: .leading) {
                Text(location.name ?? "no name")
                    .font(.headline)
                
                HStack(alignment: .top, spacing: 0.0) {
                    Text((newTemp) + "°")
                    Text(" • ")
                    Text(location.weatherCondition ?? "")
                    Spacer()
                    Text(time)
                        .onReceive(appStateViewModel.timer) { _ in
                            time = Helper.getReadableMainDate(date: Date.now, timezoneOffset: Int(location.timezone))
                        }
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            if location.weatherAlert {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
            }
        }
        .foregroundStyle(.white)
        .swipeActions {
            Button(role: .destructive) {
                persistence.deleteLocationFromContextMenu(entity: location)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            RenameButton()
        }
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
