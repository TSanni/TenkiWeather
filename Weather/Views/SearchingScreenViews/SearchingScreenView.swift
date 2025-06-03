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
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    
    
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            if !locationSearchViewModel.query.isEmpty {
                List(locationSearchViewModel.suggestions, id: \.self) { suggestion in
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
                        locationSearchViewModel.fetchCityLocation(for: suggestion) { coordinate, name, error in
                            if let error = error {
                                fatalError("Failed at fetchCityLocation function: \(error)")
                            }
                            
                            guard let coordinate = coordinate, let name = name else { return }
                            Task {
                                await appStateViewModel.getWeatherFromLocationSearch(coordinate: coordinate, name: name)
                                locationSearchViewModel.query = ""
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
        }
        .foregroundStyle(.primary)
        .contentShape(Rectangle())
        .background(colorScheme == .dark ? K.ColorsConstants.goodDarkTheme : K.ColorsConstants.goodLightTheme)
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
                locationSearchViewModel.query = ""
            } label: {
                Image(systemName: "arrow.left")
                    .contentShape(Rectangle())
                    .padding()
            }
            TextField("Search for a location", text: $locationSearchViewModel.query)
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
