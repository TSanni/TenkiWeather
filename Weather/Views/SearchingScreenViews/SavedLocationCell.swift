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
    @State private var showPinLocationAlert: Bool = false
    @State private var showDeleteConfirmationAlert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            SavedLocationImageView(imageName: location.sfSymbol ?? "snowflake")
            
            VStack(alignment: .leading) {
                if location.isFavorite {
                    HStack {
                        Image(systemName: "pin.fill")
                            .foregroundStyle(.yellow)
                        Text("Preferred Location")
                        Spacer()
                    }
                }
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
            Button(role: .none) {
                showDeleteConfirmationAlert.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)

            Button {
                showDetails.toggle()
            } label: {
                Label("More Info", systemImage: "info.circle.fill")
            }
            .tint(.orange)

        }
        .swipeActions(edge: .leading) {
            Button {
                showPinLocationAlert.toggle()
            } label: {
                Label(pinLocationTitle, systemImage: location.isFavorite ? "pin.slash.fill" : "pin.fill")
            }
            .tint(.yellow)

        }
        .alert(pinLocationTitle, isPresented: $showPinLocationAlert) {
            Button("Ok", role: .none) {
                persistence.toggleFavoriteLocation(entity: location)
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(pinLocationMessage)
        }
        .alert("Delete", isPresented: $showDeleteConfirmationAlert) {
            Button("Ok", role: .none) {
                persistence.deleteLocationFromContextMenu(location: location)
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Delete this location from saved locations?")
        }
        .contextMenu {
            Button {
                showPinLocationAlert.toggle()
            } label: {
                Label(pinLocationTitle, systemImage: location.isFavorite ? "pin.slash.fill" : "pin.fill")
            }
            .tint(.yellow)
            Button {
                showDetails.toggle()
            } label: {
                Label("More Info", systemImage: "info.circle.fill")
            }
            Button(role: .destructive) {
                showDeleteConfirmationAlert.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
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
    
    var pinLocationTitle: String {
        location.isFavorite ? "Unpin" : "Pin"
    }
    
    var pinLocationMessage: String {
        location.isFavorite ? "Unpinning this location means future default updates will be based on the current location." : "Pinning this location means future default updates will be based on this location."
    }
}
