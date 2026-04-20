//
//  SettingsScreen.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/10/24.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dimiss
    @EnvironmentObject var appStateViewModel: AppStateViewModel
 
    var body: some View {
        List {
            SaveLocationSection()
            
            TemperatureSection()
            
            DistanceAndSpeedSection()
            
            PrecipitationSection()
            
            PressureSection()
            
            SupportSection()
            
            TimeSection()
            
            ExtraSection()
            
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
                .padding(.vertical)
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
        .sheet(isPresented: $appStateViewModel.showPrivacyWebsite) {
            FullScreenWebview(url: K.privacyPolicyURL)
        }
        .sheet(isPresented: $appStateViewModel.showTermsAndConditionsWebsite) {
            TermsAndConditionsScreen()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsScreen()
            .environmentObject(AppStateViewModel.preview)
    }
}
