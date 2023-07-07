//
//  SettingsScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/28/23.
//

import SwiftUI



struct SettingsScreen: View {
    @AppStorage("unittemperature") var temperatureUnit = "Fahrenheit"
    @AppStorage("unitdistance") var distanceUnit = "Miles per hour"
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var persistence: SavedLocationsPersistence
    @Environment(\.colorScheme) var colorScheme
    

    var tempUnits = ["Fahrenheit", "Celsius", "Kelvin"]
    var distances = ["Miles per hour", "Kilometers per hour", "Meters per second", "Knots"]
    
    
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
            let darkTheme = K.Colors.goodDarkTheme.clipShape(RoundedRectangle(cornerRadius: 10))
            let lightTheme = K.Colors.goodLightTheme.clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            
            colorScheme == .light ? lightTheme : darkTheme
            
            VStack {
                HStack {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            appStateManager.showSettingScreen = false
                        }
                    Spacer()
                    Text("Weather")
                    Spacer()
                }
                .font(.title)
                
                List {
        
                    Picker(selection: $temperatureUnit) {
                        ForEach(tempUnits, id: \.self) { i in
                            Text(i)
                        }
                    } label: {
                        Label("Temperature", systemImage: "thermometer")
                    }
                    .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                    .listRowSeparator(.hidden)

                    
                    
                    Picker(selection: $distanceUnit) {
                        ForEach(distances, id: \.self) { i in
                            Text(i)
                        }
                    } label: {
                        Label("Distance", systemImage: "ruler")
                    }
                    .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                    .listRowSeparator(.hidden)

                    
//                    Button {
//                        print("Send feedback pressed!")
//                    } label: {
//                        Label("Send feedback", systemImage: "message")
//                    }
//                    .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
//                    .listRowSeparator(.hidden)
                    
                    
                    SendMailView()
                        .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                        .listRowSeparator(.hidden)
                    
                    
                    Button {
                        persistence.addLocation(locationDictionary: appStateManager.searchedLocationDictionary)
                    } label: {
                        Label {
                            VStack {
                                Text("\(appStateManager.searchedLocationDictionary["name"] as? String ?? "")")
                                    .foregroundColor(.green)
                                Text("Click to save this location")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                            }
                        } icon: {
                            Image(systemName: "map")
                        }

                    }
                    .listRowBackground(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                    .listRowSeparator(.hidden)

                }
                .background(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scrollDisabled(true)
                
                HStack {
                    Text("Privacy Policy")
                    Text("·")
                    Text("Terms of Service")

                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .foregroundColor(colorScheme == .light ? .black : .white)
        
        
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .previewDevice("iPhone 11 Pro Max")
            .frame(height: 500)
            .frame(width: 400)
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())

    }
}
