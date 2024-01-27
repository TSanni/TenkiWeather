//
//  CurrentLocationView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct CurrentLocationView: View {
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel


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
                    SavedLocationImageView(imageName: weatherViewModel.localsfSymbol)
                    
                    VStack(alignment: .leading) {
                        locationName
                        Text(weatherViewModel.localTemp + " • " + weatherViewModel.localConditions)
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
    CurrentLocationView()
        .environmentObject(CoreLocationViewModel())
        .environmentObject(WeatherViewModel())
}
