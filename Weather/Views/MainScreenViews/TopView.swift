//
//  TopView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/9/24.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
            HStack {
                Button {
                    appStateViewModel.toggleShowSearchScreen()
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text(locationManager.searchedLocationName)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                
                Spacer()
                
                Button {
                    appStateViewModel.toggleShowSettingScreen()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .padding()
                        .contentShape(Rectangle())
                }
            }
            .foregroundStyle(.white)
            .shadow(radius: 10)
    }
}

#Preview {
    TopView()
        .environmentObject(AppStateViewModel.shared)
        .environmentObject(WeatherViewModel.shared)
        .environmentObject(CoreLocationViewModel.shared)
        .environmentObject(SavedLocationsPersistenceViewModel.shared)
        .environmentObject(NetworkMonitor())
        .background(Color.indigo)
}
