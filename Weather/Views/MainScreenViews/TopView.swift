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
    @EnvironmentObject var weatherViewModel: WeatherViewModel

    var body: some View {
        let blendColor1 = appStateViewModel.mixColorWith70PercentWhite(themeColor: weatherViewModel.currentWeather.backgroundColor)

        HStack {
            Button {
                appStateViewModel.toggleShowSearchScreen()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            Text(locationManager.searchedLocationName)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .onTapGesture {
                    appStateViewModel.toggleShowSearchScreen()
                }
            Spacer()
            
            Button {
                appStateViewModel.toggleShowSettingScreen()
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(.white)
            } 
        }
        .foregroundStyle(blendColor1)
        .font(.headline)
        .shadow(radius: 10)
        .padding()
    }
}

#Preview {
        TopView()
            .environmentObject(AppStateViewModel.shared)
            .environmentObject(CoreLocationViewModel.shared)
            .environmentObject(WeatherViewModel.shared)
            .background(Color.indigo)
}
