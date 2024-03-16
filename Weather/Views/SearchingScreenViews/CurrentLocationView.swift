//
//  CurrentLocationView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct CurrentLocationView: View {
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    let localWeather: TodayWeatherModel
    @State private var time = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "mappin")
                        .renderingMode(.original)
                    Text("Current Location")
                }
                .padding(.bottom)
                
                
                HStack {
                    SavedLocationImageView(imageName: localWeather.symbolName)

                    VStack(alignment: .leading) {
                        locationName
                        HStack(spacing: 0.0) {
                            Text(localWeather.currentTemperature + "° • " + localWeather.weatherDescription)
                            Spacer()
                            Text(time)
                                .onReceive(appStateViewModel.timer) { _ in
                                    time = Helper.getReadableMainDate(date: Date.now, timezoneOffset: localWeather.timezeone)
                                }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
  
    var locationName: some View {
        
        if locationManager.localLocationName == "" {
            Text("Tap to reload")
                .font(.headline)

        } else {
            Text(locationManager.localLocationName)
                .font(.headline)
        }
    }
}

#Preview {
    CurrentLocationView(localWeather: TodayWeatherModel.holderData)
        .environmentObject(CoreLocationViewModel.shared)
        .environmentObject(WeatherViewModel.shared)
        .environmentObject(AppStateViewModel.shared)
}
