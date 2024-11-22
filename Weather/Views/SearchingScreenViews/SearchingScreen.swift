//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreen: View {
    @State private var showGoogleSearchScreen: Bool = false
    @State private var isEditing: Bool = false // Tracks editing state
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .onTapGesture {
                        Task {
                            await appStateViewModel.getWeatherAndUpdateDictionaryFromLocation()
                        }
                    }
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                    
                    Spacer()

                    Button(isEditing ? "Done" : "Edit") {
                        toggleEditMode()
                    }
                }
                
                CustomDivider()
                
                SavedLocationsView()
                    .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive)) // Manage edit mode
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
                }
            }
        }
    }
    
    // Toggle the editing mode
        private func toggleEditMode() {
            withAnimation {
                isEditing.toggle()
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
