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
    let backgroundColor: Color

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
                        Spacer()
                        
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
            .background(backgroundColor.brightness(-0.1))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal)
            .shadow(color: .black, radius: 0, y: 0.5)
            .shadow(radius: 3)

    }
}

#Preview {
    ZStack {
        Color.orange
        TopView(backgroundColor: .indigo)
            .environmentObject(AppStateViewModel.shared)
            .environmentObject(WeatherViewModel.shared)
            .environmentObject(CoreLocationViewModel.shared)
            .environmentObject(SavedLocationsPersistenceViewModel.shared)
            .environmentObject(NetworkMonitor())
    }
}
