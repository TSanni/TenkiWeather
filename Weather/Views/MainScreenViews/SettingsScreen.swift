//
//  SettingsScreen.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/10/24.
//

import SwiftUI

struct SettingsScreen: View {
    @AppStorage(K.UserDefaultKeys.unitTemperatureKey) var temperatureUnit: TemperatureUnits = .fahrenheit
    @AppStorage(K.UserDefaultKeys.unitDistanceKey) var distanceUnit: DistanceUnits = .miles
    @Environment(\.dismiss) var dimiss
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
    
    @State private var locationSaved: Bool = false
    @State private var showPrivacyWebsite = false
    @State private var showTermsAndConditionsWebsite = false
    
    @State private var alertTitle: Text = Text("")
    @State private var alertMessage: Text = Text("")
    
    var body: some View {
        List {
            
            Section("Save Location") {
                Button {
                    saveLocation()
                } label: {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(appStateViewModel.searchedLocationDictionary[K.LocationDictionaryKeysConstants.name] as? String ?? "")")
                                .foregroundStyle(.green)
                            
                            Text("Click to save this location")
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        }
                        
                        Spacer()
                    }
                }
                .tint(.primary)
                
            }
            
            
            Section("Temperature") {
                ForEach(TemperatureUnits.allCases, id: \.title) { unit in
                    HStack {
                        Text(unit.title + " " + unit.symbol)
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
            }
            
            Section("Distance and Speed") {
                ForEach(DistanceUnits.allCases, id: \.title) { unit in
                    HStack {
                        Text(unit.title)
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
            
            Section("Support") {
                SendMailView()
            }
            
            Section {
                Text("Privacy Policy").onTapGesture { showPrivacyWebsite = true }
                Text("Terms and Conditions").onTapGesture { showTermsAndConditionsWebsite = true }
            }
        }
        .navigationTitle("Tenki Weather")
        .toolbar {
            ToolbarItem {
                Button("Dismiss") {
                    dimiss()
                }
                .tint(.primary)
            }
        }
        .alert(isPresented: $locationSaved) {
            Alert(title: alertTitle, message: alertMessage)
        }
        .fullScreenCover(isPresented: $showPrivacyWebsite) {
            FullScreenWebView(url: K.privacyPolicyURL)
        }
        .fullScreenCover(isPresented: $showTermsAndConditionsWebsite) {
            TermsAndConditionsView()
        }
    }
    
    
    private func saveLocation() {
        
        if persistence.savedLocations.count >= 10 {
            alertTitle = Text("Error")
            alertMessage = Text("Can't save location. Remove some saved locations before trying again.")
        } else {
            alertTitle = Text("Saved")
            alertMessage =  Text("Location saved to favorites")
            persistence.addLocation(locationDictionary: appStateViewModel.searchedLocationDictionary)
        }
        
        locationSaved.toggle()
    }
}

#Preview {
    NavigationView {
        SettingsScreen()
            .environmentObject(AppStateViewModel.shared)
            .environmentObject(SavedLocationsPersistenceViewModel.shared)
    }
}
