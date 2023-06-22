//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreen: View {
    @State private var searchText: String = ""
    @FocusState private var focusSearch: Bool
    @Binding var showSearchScreen: Bool
    @Environment(\.colorScheme) var colorScheme
    //    @EnvironmentObject var vm: WeatherViewModel
    //    @EnvironmentObject var vm: SavedLocationsPersistence
    
    //    let today: TodayWeatherModel
    
    /// All saved locations in core data
    let todayCollection: [LocationEntity]
    
    //MARK: - Main View
    var body: some View {
        VStack {
            textFieldAndBackButton
            
            CustomDivider()
            
            VStack {
                //TODO: Add support for CoreLocation to get the weather
                currentLocation
                
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                CustomDivider()
                
                SavedLocationsView(todayCollection: todayCollection)
            }
            .padding()
        }
        .contentShape(Rectangle())
        
        .onAppear {
            focusSearch = true
        }
        .onTapGesture {
            focusSearch = false
        }
        .background(colorScheme == .light ? Color.white : Color(uiColor: K.Colors.properBlack))
        //        .task {
        //
        //            do {
        //                 try await vm.fetchWeatherPlacesWithTaskGroup()
        //            } catch {
        //                print("\(error)")
        //            }
        //        }
        
        
        
    }
    
    
    
    //MARK: - Textfield and Back button
    var textFieldAndBackButton: some View {
        HStack {
            Button {
                withAnimation {
                    showSearchScreen = false
                }
                
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .padding()
            }
            
            TextField(text: $searchText) {
                Text("Search places")
            }
            .focused($focusSearch)
            .tint(Color(uiColor: K.Colors.textFieldBlinkingBarColor))
        }
    }
    
    
    //MARK: - Current Location
    var currentLocation: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Rosenberg, TX 77471")
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
                    Text("77").font(.title)
                    Text("°F")
                }
                .foregroundColor(.secondary)
                
                Image(systemName: "sun.max")
            }
        }
        .padding(.bottom)
        
    }
    
    
}





struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchingScreen(showSearchScreen: .constant(true), todayCollection: [])
            .environmentObject(SavedLocationsPersistence())
    }
}
