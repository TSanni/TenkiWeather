//
//  PlaceDetails.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/11/24.
//

import SwiftUI
import CoreLocation
struct PlaceDetails: View {
    @EnvironmentObject var coreLocationViewModel: CoreLocationViewModel
    @State private var placeInfo: CLPlacemark? = nil
    let name: String
    let latitude: Double
    let longitude: Double

    var body: some View {
        ZStack(alignment: .topLeading) {
            K.ColorsConstants.tenDayBarColor.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Details")
                    .font(.title)
                    .padding(.bottom)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Name")
                        .foregroundStyle(.secondary)
                    Text(name)
                }
                Divider()
                
                if let country = placeInfo?.country {
                    VStack(alignment: .leading) {
                        Text("Country")
                            .foregroundStyle(.secondary)
                        HStack {
                            Text(country)
                                .foregroundStyle(.primary)
                            if let countryCode = placeInfo?.isoCountryCode, let url = URL(string: "https://flagsapi.com/\(countryCode)/flat/64.png") {
                                AsyncImage(url: url) { image in
                                    if let img = image.image {
                                        img
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
                
                VStack(alignment: .leading) {
                    Text("Coordinates")
                        .foregroundStyle(.secondary)
                    Text("Latitude: \(latitude), Longitude: \(longitude)")
                        .foregroundStyle(.primary)
                }

                if let timezone = placeInfo?.timeZone {
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Timezone")
                            .foregroundStyle(.secondary)
                        Text(timezone.description)
                            .foregroundStyle(.primary)
                    }
                }
            }
            .padding()
            .background(K.ColorsConstants.tenDayBarColor)
            .task {
                placeInfo = await coreLocationViewModel.getPlaceDataFromCoordinates(latitude: latitude, longitude: longitude)
            }
        }
    }
}

#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        PlaceDetails(name: "Place name", latitude: 29.600616, longitude: -95.808278)
            .presentationDetents([.fraction(0.4), .medium])
    }
    .environmentObject(CoreLocationViewModel.shared)
}
