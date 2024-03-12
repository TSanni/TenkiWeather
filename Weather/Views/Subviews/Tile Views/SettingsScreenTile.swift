//
//  SettingsScreenTile.swift
//  Weather
//
//  Created by Tomas Sanni on 6/28/23.
//

import SwiftUI



//struct SettingsScreenTile: View {
//    @Environment(\.colorScheme) var colorScheme
//    @AppStorage(K.UserDefaultKeys.unitTemperatureKey) var temperatureUnit: TemperatureUnits = .fahrenheit
//    @AppStorage(K.UserDefaultKeys.unitDistanceKey) var distanceUnit: DistanceUnits = .miles
//    @EnvironmentObject var appStateViewModel: AppStateViewModel
//    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
//    @State private var locationSaved: Bool = false
//    @State private var showPrivacyWebsite = false
//    @State private var showTermsAndConditionsWebsite = false
//
//    @State private var alertTitle: Text = Text("")
//    @State private var alertMessage: Text = Text("")
//
//    var body: some View {
//
//        VStack(alignment: .leading) {
//            header
//            
//            listContent
//            
//            footer
//        }
//        .settingsFrame(colorScheme: colorScheme)
//        .alert(isPresented: $locationSaved) {
//            Alert(title: alertTitle, message: alertMessage)
//        }
//        .fullScreenCover(isPresented: $showPrivacyWebsite) {
//            FullScreenWebView(url: K.privacyPolicyURL)
//        }
//        .fullScreenCover(isPresented: $showTermsAndConditionsWebsite) {
//            TermsAndConditionsView()
//        }
//
//
//    }
//    
//    
//    var header: some View {
//        HStack {
//            Button {
//                appStateViewModel.showSettingScreen = false
//            } label: {
//                Image(systemName: "xmark")
//            }
//            
//            Spacer()
//            
//            Text("Tenki Weather")
//            
//            Spacer()
//        }
//        .font(.largeTitle)
//    }
//    
//    var listContent: some View {
//        let darkTheme = K.ColorsConstants.goodDarkTheme.clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
//        let lightTheme = K.ColorsConstants.goodLightTheme.clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
//        
//      return VStack {
//            
//            List {
//                Picker(selection: $temperatureUnit) {
//                    ForEach(TemperatureUnits.allCases, id: \.self) {
//                        Text($0.title)
//                    }
//                } label: {
//                    LabelView(title: "Thermometer", iconSymbol: "thermometer.medium")
//                }
//                .settingsListBackgroundChange()
//                
//                
//                Picker(selection: $distanceUnit) {
//                    ForEach(DistanceUnits.allCases, id: \.self) {
//                        Text($0.title)
//                    }
//                } label: {
//                    LabelView(title: "Distance", iconSymbol: "ruler")
//                }
//                .settingsListBackgroundChange()
//                
//                SendMailView()
//                    .settingsListBackgroundChange()
//                
//                Button {
//                    saveLocation()
//                } label: {
//                    HStack {
//                        Image(systemName: "mappin.and.ellipse")
//                            .font(.title)
//                        
//                        Spacer()
//                        
//                        VStack {
//                            Text("\(appStateViewModel.searchedLocationDictionary[K.LocationDictionaryKeysConstants.name] as? String ?? "")")
//                                .foregroundStyle(.green)
//                            
//                            Text("Click to save this location")
//                                .foregroundStyle(.secondary)
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.2)
//                        }
//                        
//                        Spacer()
//                    }
//                }
//                .settingsListBackgroundChange()
//                
//            }
//            .scrollContentBackground(.hidden)
//            .listStyle(.plain)
//            .clipShape(RoundedRectangle(cornerRadius: K.tileCornerRadius))
//            .scrollIndicators(.hidden)
//            .background (
//                colorScheme == .light ?
//                lightTheme.brightness(-0.03) : darkTheme.brightness(-0.03)
//            )
//            
//        }
//    }
//    
//    var footer: some View {
//        HStack {
//            Spacer()
//            Text("Privacy Policy")
//                .onTapGesture { showPrivacyWebsite = true }
//            
//            Text("•")
//            
//            Text("Terms and Conditions")
//                .onTapGesture { showTermsAndConditionsWebsite = true }
//            
//            Spacer()
//        }
//    }
//    
//    
//    
//    private func saveLocation() {
//        
//        if persistence.savedLocations.count >= 10 {
//            alertTitle = Text("Error")
//            alertMessage = Text("Can't save location. Remove some saved locations before trying again.")
//        } else {
//            alertTitle = Text("Saved")
//            alertMessage =  Text("Location saved to favorites")
//            persistence.addLocation(locationDictionary: appStateViewModel.searchedLocationDictionary)
//        }
//        
//        locationSaved.toggle()
//    }
//}
//
//
//#Preview {
//    ZStack {
//        Color.gray.ignoresSafeArea()
//        SettingsScreenTile()
//            .environmentObject(AppStateViewModel.shared)
//            .environmentObject(SavedLocationsPersistenceViewModel.shared)
//    }
//}
