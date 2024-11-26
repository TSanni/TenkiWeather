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
    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var placeInfo: CLPlacemark? = nil
    @State private var textFieldText = ""
    let name: String
    let latitude: Double
    let longitude: Double
    @ObservedObject var location: Location
    

    var body: some View {
        ZStack(alignment: .topLeading) {
            K.ColorsConstants.tenDayBarColor.ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack {
                    Text("Details")
                        .font(.largeTitle)
                    
                    Spacer()

                    Button("Dismiss") {
                        dismiss()
                    }
                }
                .padding(.bottom)

                Divider()
                
                VStack(alignment: .leading) {
                    Text("Name")
                        .foregroundStyle(.secondary)
                    TextField("Enter name", text: $textFieldText)
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                        .onSubmit {
                            persistence.updateLocationName(entity: location, newName: textFieldText)
                        }
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
                
                
                HStack {
                    Spacer()
                    
                    Button("Save") {
                        persistence.updateLocationName(entity: location, newName: textFieldText)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(K.ColorsConstants.goodLightTheme)
                    .shadow(radius: 5)
                    .foregroundStyle(K.ColorsConstants.tenDayBarColor)
                    
                    Spacer()
                }
            }
            .padding()
            .background(K.ColorsConstants.tenDayBarColor)
            .task {
                placeInfo = await coreLocationViewModel.getPlaceDataFromCoordinates(latitude: latitude, longitude: longitude)
            }
        }
        .navigationTitle("Details")
        .foregroundStyle(.white)
        .onAppear {
            textFieldText = location.name ?? "no name"
        }
    }
}

