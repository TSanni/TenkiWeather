//
//  SettingsScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/28/23.
//

import SwiftUI

class AppStateManager: ObservableObject {
    @Published var showSearchScreen: Bool = false
    @Published var searchNameIsInPlacesArray: Bool = true
    
    
    @Published var temperatureDistance: UnitLength = .miles
}


struct SettingsScreen: View {
    @AppStorage("unittemperature") var temperatureUnit = "fahrenheit"
    @AppStorage("unitdistance") var distanceUnit = "Miles per hour"
    @EnvironmentObject var appStateManager: AppStateManager
    
    var tempUnits = ["fahrenheit", "celsius", "kelvin"]
    var distances = ["Miles per hour", "Kilometers per hour", "Meters per second", "Knots"]
    
    
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
//            Color(uiColor: K.Colors.properBlack).clipShape(RoundedRectangle(cornerRadius: 10))
            Color.red.clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                HStack {
                    Image(systemName: "xmark")
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
                        Label("Temperature Units", systemImage: "thermometer")
                    }
                    
                    
                    
                    Picker(selection: $distanceUnit) {
                        ForEach(distances, id: \.self) { i in
                            Text(i)
                                .foregroundColor(.orange)
                        }
                    } label: {
                        Label("Distance Units", systemImage: "ruler")
                    }

                    
                    Button {
                        print("Send feedback pressed!")
                    } label: {
                        Label("Send feedback", systemImage: "message")
                    }
                }
                .foregroundColor(.purple)
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    Text("Privacy Policy")
                    Text("·")
                    Text("Terms of Service")

                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        
        
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .frame(height: 300)
            .frame(width: 400)
            .environmentObject(AppStateManager())
    }
}
