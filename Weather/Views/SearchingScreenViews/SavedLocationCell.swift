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
    @State private var showDetails = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            SavedLocationImageView(imageName: location.sfSymbol ?? "snowflake")
            
            VStack(alignment: .leading) {
                HStack {
                    Text(location.name ?? "no name")
                        .font(.headline)
                    
                    Spacer()
                    
                    if location.weatherAlert {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                HStack(alignment: .top, spacing: 0.0) {
                    Text((newTemp) + "°")
                    Text(" • ")
                    Text(location.weatherCondition ?? "")
                    Spacer()
                    Text(time)
                        .onReceive(K.timer) { _ in
                            time = Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: location.timezoneIdentifier ?? K.defaultTimezoneIdentifier)
                        }
                }
                .font(.subheadline)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .swipeActions {
            Button(role: .destructive) {
                persistence.deleteLocationFromContextMenu(location: location)
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                showDetails.toggle()
            } label: {
                Label("More Info", systemImage: "info.circle.fill")
            }
            .tint(.orange)

        }
        .contextMenu {
            Button {
                showDetails.toggle()
            } label: {
                Label("More Info", systemImage: "info.circle.fill")
            }
            Button(role: .destructive) {
                persistence.deleteLocationFromContextMenu(location: location)
            } label: {
                Text("Delete")
            }
            
        }
        .sheet(isPresented: $showDetails) {
            NavigationStack {
                PlaceDetails(name: location.name ?? "No name", latitude: location.latitude, longitude: location.longitude, location: location)
                    .presentationDetents([.height(500)])
            }
        }
    }

    var newTemp: String {
        let pureTemp = location.temperature ?? "0"
        let pureTempToDouble = Double(pureTemp) ?? 0
        let measurementValueOfPureTemp: Measurement<UnitTemperature> = Measurement(value: pureTempToDouble, unit: .celsius)
        let measurementValueSavedInUserDefaults = measurementValueOfPureTemp.converted(to: Helper.getUnitTemperature())
        let newTempValue = measurementValueSavedInUserDefaults.value
        let newTempValueAsString =  String(format: "%.0f", newTempValue)
        
        return newTempValueAsString
    }
}
