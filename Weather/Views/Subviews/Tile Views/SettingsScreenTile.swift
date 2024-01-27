//
//  SettingsScreenTile.swift
//  Weather
//
//  Created by Tomas Sanni on 6/28/23.
//

import SwiftUI

enum TemperatureUnits: String, CaseIterable {
    case fahrenheit = "Fahrenheit"
    case celsius = "Celsius"
    case kelvin = "Kelvin"
}

enum DistanceUnits: String, CaseIterable {
    case miles = "Miles per hour"
    case kilometer = "Kilometers per hour"
    case meters = "Meters per second"
    case knots = "Knots"
}



struct SettingsScreenTile: View {
    @AppStorage(K.UserDefaultKeys.unitTemperatureKey) var temperatureUnit: TemperatureUnits = .fahrenheit
    @AppStorage(K.UserDefaultKeys.unitDistanceKey) var distanceUnit: DistanceUnits = .miles
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var persistence: SavedLocationsPersistence
    @Environment(\.colorScheme) var colorScheme
    @State private var locationSaved: Bool = false
    @State private var showPrivacyWebsite = false
    @State private var showTermsAndConditionsWebsite = false
    
    @State private var alertTitle: Text = Text("")
    @State private var alertMessage: Text = Text("")
    
//    @State private var tempUnits2: TemperatureUnits = .fahrenheit
    
//    var tempUnits = ["Fahrenheit", "Celsius", "Kelvin"]
//    var distances = ["Miles per hour", "Kilometers per hour", "Meters per second", "Knots"]
    
    
    
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
                    Text("Tenki Weather")
                    Spacer()
                }
                .font(.title)
                
                List {
                    
                    Picker(selection: $temperatureUnit) {
                        ForEach(TemperatureUnits.allCases, id: \.self) { i in
                            Text(i.rawValue)
                        }
                    } label: {
                        LabelView(title: "Temperature", iconSymbol: "thermometer")
                    }
                    .settingsListBackgroundChange()
                    
                    
                    
                    Picker(selection: $distanceUnit) {
                        ForEach(DistanceUnits.allCases, id: \.self) { i in
                            Text(i.rawValue)
                        }
                    } label: {
                        LabelView(title: "Distance", iconSymbol: "ruler")
                    }
                    .settingsListBackgroundChange()

                    
                    
                    SendMailView()
                        .settingsListBackgroundChange()
                    
                    
                    
                    Button {
                        
                        if persistence.savedLocations.count >= 10 {
                            alertTitle = Text("Error")
                            alertMessage = Text("Can't save location. Remove some saved locations before trying again.")
                        } else {
                            alertTitle = Text("Saved")
                            alertMessage =  Text("Location saved to favorites")
                            persistence.addLocation(locationDictionary: appStateManager.searchedLocationDictionary)
                        }
                        locationSaved.toggle()
                        
                        
                    } label: {
                        Label {
                            VStack(alignment: .center) {
                                Text("\(appStateManager.searchedLocationDictionary[K.LocationDictionaryKeys.name] as? String ?? "")")
                                    .foregroundColor(.green)
                                Text("Click to save this location")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                            }
                            .frame(maxWidth: .infinity)
                        } icon: {
                            Image(systemName: "map")
                        }
                        
                    }
                    .settingsListBackgroundChange()
                    
                }
                .background(colorScheme == .light ? lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03))
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .scrollIndicators(.hidden)
                
                HStack {
                    
                    Text("Privacy Policy")
                        .onTapGesture { showPrivacyWebsite = true }
                    
                    
                    Text("·")
                    
                    Text("Terms and Conditions")
                        .onTapGesture { showTermsAndConditionsWebsite = true }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .foregroundColor(colorScheme == .light ? .black : .white)
        .alert(isPresented: $locationSaved) {
            Alert(title: alertTitle, message: alertMessage)
        }
        .fullScreenCover(isPresented: $showPrivacyWebsite) {
            FullScreenWebView(url: "https://www.termsfeed.com/live/a13a54bd-d22e-4076-9260-29d2f89d4621")
        }
        .fullScreenCover(isPresented: $showTermsAndConditionsWebsite) {
            //FullScreenWebView(url: "https://www.termsfeed.com/live/ea65e2ba-f3a8-4de0-80f0-2719c1e43d31")
            TermsAndConditionsView()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenTile()
            .previewDevice("iPhone SE (3rd generation)")
            .frame(height: 300)
            .padding()
            .environmentObject(AppStateManager())
            .environmentObject(SavedLocationsPersistence())
        
    }
}
