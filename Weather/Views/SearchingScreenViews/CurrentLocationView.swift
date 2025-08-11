//
//  CurrentLocationView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct CurrentLocationView: View {
    @EnvironmentObject var coreLocationVM: CoreLocationViewModel
    @EnvironmentObject var appStateVM: AppStateViewModel
    @State private var time = ""
    @State private var showSettingsAlert = false

    let localWeather: TodayWeatherModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .renderingMode(.original)
                    Text("Current Location")
                }
                .padding(.bottom)
                
                HStack {
                    SavedLocationImageView(imageName: localWeather.symbolName)

                    VStack(alignment: .leading) {
                        locationName
                        HStack(spacing: 0.0) {
                            Text(localWeather.currentTemperature + " • " + localWeather.weatherDescription)
                            Spacer()
                            Text(time)
                                .onReceive(K.timer) { _ in
                                    time = Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: localWeather.timezoneIdentifier)
                                }
                        }
                    }
                }
                .onTapGesture {
                    Task {
                        if coreLocationVM.authorizationStatus == .denied {
                            showSettingsAlert = true
                        } else {
                            await appStateVM.getWeatherAndUpdateDictionaryFromCurrentLocation()
                        }
                    }
                }
                .alert(isPresented: $showSettingsAlert) {
                     Alert(
                         title: Text("Location Access Needed"),
                         message: Text("Please enable location access in Settings."),
                         primaryButton: .default(Text("Open Settings"), action: {
                             if let url = URL(string: UIApplication.openSettingsURLString) {
                                 UIApplication.shared.open(url)
                             }
                         }),
                         secondaryButton: .cancel()
                     )
                 }
            }
            
            Spacer()
        }
    }
  
    var locationName: some View {
        
        if coreLocationVM.localLocationName == "" {
            Text("Tap to reload")
                .font(.headline)

        } else {
            Text(coreLocationVM.localLocationName)
                .font(.headline)
        }
    }
}

#Preview {
    CurrentLocationView(localWeather: TodayWeatherModelPlaceHolder.holderData)
        .environmentObject(CoreLocationViewModel.preview)
        .environmentObject(AppStateViewModel.preview)
}
