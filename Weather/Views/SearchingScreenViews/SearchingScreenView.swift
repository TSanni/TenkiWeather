//
//  SearchingScreenView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreenView: View {
    @State private var isEditing: Bool = false // Tracks editing state
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var weatherVM: WeatherViewModel
    @EnvironmentObject var appStateVM: AppStateViewModel
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var savedLocationPersistenceViewModel: SavedLocationsPersistenceViewModel

    @AppStorage("ascendOrDescend") var toggleAscend = false
    
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            if !locationSearchVM.query.isEmpty {
                List(locationSearchVM.suggestions, id: \.self) { suggestion in
                    VStack(alignment: .leading) {
                        Text(suggestion.title)
                            .font(.headline)
                        Text(suggestion.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowBackground(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        locationSearchVM.fetchCityLocation(for: suggestion) { coordinate, name, error in
                            if let error = error {
                                fatalError("Failed at fetchCityLocation function: \(error)")
                            }
                            
                            guard let coordinate = coordinate, let name = name else { return }
                            Task {
                                await appStateVM.getWeatherFromLocationSearch(coordinate: coordinate, name: name)
                                locationSearchVM.query = ""
                            }
                            

                        }
                    }

                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.immediately)
            } else {
                VStack {
                    CurrentLocationView(localWeather: weatherVM.localWeather)
                        .padding(.bottom)
                        .padding(.bottom)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    HStack {
                        
                        Group {
                            Text("Saved locations")
                                .font(.headline)
                            
                            Image(systemName: toggleAscend ? "arrow.up" : "arrow.down")
                        }
                        .onTapGesture {
                            toggleAscend.toggle()
                            savedLocationPersistenceViewModel.fetchAllLocations(updateNetwork: false)
                        }
                        
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
        }
        .foregroundStyle(.primary)
        .contentShape(Rectangle())
        .background(colorScheme == .dark ? Color.goodDarkTheme : Color.goodLightTheme)
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
                appStateVM.toggleShowSearchScreen()
                locationSearchVM.query = ""
            } label: {
                Image(systemName: "arrow.left")
                    .contentShape(Rectangle())
                    .padding()
            }
            TextField("Search for a location", text: $locationSearchVM.query)
                .autocorrectionDisabled()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SearchingScreenView()
        .environmentObject(WeatherViewModel.preview)
        .environmentObject(AppStateViewModel.preview)
        .environmentObject(LocationSearchViewModel.preview)
        .environmentObject(CoreLocationViewModel.preview)
        .environmentObject(SavedLocationsPersistenceViewModel.preview)
}
