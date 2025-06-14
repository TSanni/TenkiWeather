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
    @AppStorage(K.UserDefaultKeys.unitPrecipitationKey) var precipitationUnit: PrecipitationUnits = .inches
    @Environment(\.dismiss) var dimiss
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @State private var showPrivacyWebsite = false
    @State private var showTermsAndConditionsWebsite = false
    
    
    @AppStorage(K.UserDefaultKeys.timePreferenceKey) var toggle24HourTime: Bool = false
    @AppStorage(K.UserDefaultKeys.showTemperatureUnitKey) var showTemperatureUnit: Bool = false
    
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

 
    var body: some View {
        List {
            saveLocationSection
            
            temperatureSection
            
            distanceAndSpeedSection
            
            precipitationSection
            
            supportSection
            
            timeSection
            
            extraSection
            
            HStack {
                Spacer()
                Text("Last weather update: " + appStateViewModel.lastUpdated)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .shadow(radius: 5)
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Tenki Weather")
        .toolbar {
            ToolbarItem {
                Button("Dismiss") {
                    dimiss()
                }
                .padding([.vertical, .leading])
                .tint(.primary)
            }
        }
        .alert("Saved", isPresented: $appStateViewModel.showCoreDataSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Location saved successfully.")
        }
        .alert(isPresented: $appStateViewModel.showCoreDataErrorAlert, error: appStateViewModel.coreDataError) { _ in
            Button("OK", role: .cancel) { }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later")
        }
        .sheet(isPresented: $showPrivacyWebsite) {
            FullScreenWebView(url: K.privacyPolicyURL)
        }
        .sheet(isPresented: $showTermsAndConditionsWebsite) {
            TermsAndConditionsView()
        }
    }
     
    
    //MARK: - sub views
    var saveLocationSection: some View {
        Section("Save Location") {
            Button {
                appStateViewModel.saveLocation()
            } label: {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.title)
                    
                    Spacer()
                    
                    VStack {
                    
                        Text(appStateViewModel.searchedLocationModel.name)
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
    }
    
    var temperatureSection: some View {
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
            
            Toggle(isOn: $showTemperatureUnit) {
                Text("Show unit")
            }
        }
    }
    
    var distanceAndSpeedSection: some View {
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
    }
    
    var precipitationSection: some View {
        Section("Precipitation") {
            ForEach(PrecipitationUnits.allCases, id: \.title) { unit in
                HStack {
                    Text(unit.title)
                    Spacer()
                    if precipitationUnit == unit {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    precipitationUnit = unit
                }
            }
        }
    }
    
    var supportSection: some View {
        Section("Support") {
            SendMailView()
        }
    }
    
    var timeSection: some View {
        Section("Time") {
            Toggle(isOn: $toggle24HourTime) {
                Text("Use 24-hour format")
            }
        }
    }
    
    var extraSection: some View {
        Section {
            Text("Privacy Policy").onTapGesture { showPrivacyWebsite = true }
            Text("Terms and Conditions").onTapGesture { showTermsAndConditionsWebsite = true }
            Text("App Version: \(appVersionString)")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .environmentObject(AppStateViewModel.preview)
    }
}
