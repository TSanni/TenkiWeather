//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI
import CoreData
struct SearchingScreen: View {
    @State private var searchText: String = ""
    @FocusState private var focusSearch: Bool
//    @Binding var showSearchScreen: Bool
    @Environment(\.colorScheme) var colorScheme
//    @EnvironmentObject var persistenceLocations: SavedLocationsPersistence
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var locationManager: CoreLocationViewModel
    @EnvironmentObject var appStateManager: AppStateManager
    
    /// All saved locations in core data
//    let todayCollection: [LocationEntity]
    var places: FetchedResults<LocationEntity>
    let testMOC: NSManagedObjectContext

    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            VStack {
                currentLocation
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                CustomDivider()
                
                SavedLocationsView(places: places, testMOC: testMOC)
            }
            .padding()
        }
        .contentShape(Rectangle())
        
        .onAppear {
            focusSearch = true
        }
        .background(colorScheme == .light ? Color.white : Color(uiColor: K.Colors.properBlack))
   
    }
    
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
//                withAnimation {
                focusSearch = false
                    appStateManager.showSearchScreen = false
                
//                }
                
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .padding()
            }
            
            TextField("Search places", text: $searchText)
                .focused($focusSearch)
                .tint(Color(uiColor: K.Colors.textFieldBlinkingBarColor))
                .onSubmit {
                    Task {
                        let newText = searchText.replacingOccurrences(of: " ", with: "+")
                        let coordinates = try await locationManager.getCoordinatesFromName(name: newText)
                        let timezone = locationManager.timezoneForCoordinateInput
                        print("COORDINATES: \(coordinates)")
                        await weatherViewModel.getWeather(latitude: coordinates.coordinate.latitude, longitude:coordinates.coordinate.longitude, timezone: timezone)
                        
//                        for i in places {
//                            if let a = i.name {
//                                if a.contains(locationManager.currentLocationName) {
//                                    appStateManager.searchNameIsInPlacesArray = true
//                                    break
//                                } else {
//                                    appStateManager.searchNameIsInPlacesArray = false
//                                    break
//                                }
//                            }
//                        }
                            appStateManager.showSearchScreen = false
                            
                            
                            
                            
                            
                    }
                }
            
        }
    }
    
    
    //MARK: - Current Location
    var currentLocation: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weatherViewModel.localName)
                    .font(.headline)
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    Text("Your location")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack {
                HStack(alignment: .top, spacing: 0.0) {
                    Text(weatherViewModel.localTemp).font(.title)
                    Text("°F")
                }
                .foregroundColor(.secondary)
                
                Image(systemName: WeatherManager.shared.getImage(imageName: weatherViewModel.localsfSymbol))
                    .renderingMode(.original)
            }
        }
        .padding(.bottom)
        .onTapGesture {
            Task {
                await locationManager.getNameFromCoordinates(latitude: locationManager.latitude, longitude: locationManager.longitude)
                let timezone = locationManager.timezoneForCoordinateInput
                await weatherViewModel.getWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, timezone: timezone)
                let userLocationName = locationManager.currentLocationName
                await weatherViewModel.getLocalWeather(latitude: locationManager.latitude, longitude: locationManager.longitude, name: userLocationName, timezone: timezone)
                appStateManager.showSearchScreen = false

//                persistenceLocations.saveData()
                

            }
        }
    }
}





//struct SearchingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchingScreen()
////            .environmentObject(SavedLocationsPersistence())
//    }
//}
