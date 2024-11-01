//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreen: View {
    @State private var showGoogleSearchScreen: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var persistenceLocations: SavedLocationsPersistenceViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @AppStorage("sortType") var sortType = "name"
    @AppStorage("ascending") var ascending = false
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            VStack {
                CurrentLocationView(localWeather: weatherViewModel.localWeather)
                    .padding(.bottom)
                    .padding(.bottom)
                    .onTapGesture {
                        Task {
                            await appStateViewModel.getWeatherAndUpdateDictionaryFromLocation()
                            persistenceLocations.saveData()
                        }
                    }
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                    
                    Spacer()
                    
                    Menu {
                        Text("Sort locations by:")
                        Button {
                            if sortType == "name" {
                                ascending.toggle()
                            }
                            
                            sortType = "name"
                            persistenceLocations.fetchLocationsWithUserDeterminedOrder(key: sortType, ascending: ascending)
                        } label: {
                            HStack {
                                if sortType == "name" {
                                    Image(systemName: "checkmark")
                                }
                                Text("Name")
                            }
                        }
                        
                        Button {
                            if sortType == "timeAdded" {
                                ascending.toggle()
                            }
                            sortType = "timeAdded"
                            persistenceLocations.fetchLocationsWithUserDeterminedOrder(key: sortType, ascending: ascending)
                        } label: {
                            HStack {
                                if sortType == "timeAdded" {
                                    Image(systemName: "checkmark")
                                }
                                Text("Date Added")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding(.leading)
                    }

                }
                
                CustomDivider()
                
                SavedLocationsView()
            }
            .padding()
        }
        .foregroundStyle(.white)
        .contentShape(Rectangle())
        .background(K.ColorsConstants.goodDarkTheme)
        .sheet(isPresented: $showGoogleSearchScreen) {
            PlacesViewControllerBridge { place in
                Task {
                    await appStateViewModel.getWeatherWithGoogleData(place: place)
                    persistenceLocations.saveData()
                }
                
            }
        }
    }
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
                appStateViewModel.toggleShowSearchScreen()
            } label: {
                Image(systemName: "arrow.left")
                    .contentShape(Rectangle())
                    .padding()
            }
            
            Text("Search for a location")
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    DispatchQueue.main.async {
                        showGoogleSearchScreen = true
                    }
                }
        }
    }
}

#Preview {
    SearchingScreen()
        .environmentObject(WeatherViewModel.shared)
        .environmentObject(CoreLocationViewModel.shared)
        .environmentObject(AppStateViewModel.shared)
        .environmentObject(SavedLocationsPersistenceViewModel.shared)
}
