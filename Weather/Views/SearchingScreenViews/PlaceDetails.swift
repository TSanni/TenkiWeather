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

                            if let countryCode = placeInfo?.isoCountryCode, let url = URL(string: "https://flagsapi.com/\(countryCode)/flat/64.png") {
                                
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 25, height: 25)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    case .failure:
                                        ProgressView()
                                    @unknown default:
                                        ProgressView()
                                            .frame(width: 25, height: 25)
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
                
                if let administrativeArea = placeInfo?.administrativeArea {
                    VStack(alignment: .leading) {
                        Text("Administrative Area")
                            .foregroundStyle(.secondary)
                        Text(administrativeArea)
                    }
                    Divider()
                }
                
                VStack(alignment: .leading) {
                    Text("Coordinates")
                        .foregroundStyle(.secondary)
                    
                    Text("Lat: \(latitude), Lon: \(longitude)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .contextMenu(menuItems: {
                            Button {
                                UIPasteboard.general.string = latitude.description
                            } label: {
                                Label("Copy Latitude", systemImage: "doc.on.doc")
                            }
                            
                            Button {
                                UIPasteboard.general.string = longitude.description
                            } label: {
                                Label("Copy Longitude", systemImage: "doc.on.doc")
                            }
                        })
                }

                if let timezone = placeInfo?.timeZone {
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Timezone")
                            .foregroundStyle(.secondary)
                        Text(timezone.description)
                        Text("\(timezone.secondsFromGMT())")
                    }
                }
            }
            .padding()
            .background(K.ColorsConstants.tenDayBarColor)
            .task {
                placeInfo = await coreLocationViewModel.getPlaceDataFromCoordinates(latitude: latitude, longitude: longitude)
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        PlaceDetails(name: "Place name", latitude: 29.600616, longitude: -95.808278)
            .presentationDetents([.medium, .large])
    }
    .environmentObject(CoreLocationViewModel.shared)
}
