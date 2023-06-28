//
//  SettingsScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/28/23.
//

import SwiftUI

struct SettingsScreen: View {
    enum Temps: String, CaseIterable {
        case fahrenheit = "Fahrenheit"
        case celsius = "Celsius"
        case kelvin = "Kelvin"
    }
    
    
    var distances = ["mph", "kph", "m/s"]
    @State private var tempSelection: Temps = .fahrenheit
    @State private var distanceSelection = "mph"
    
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
//            Color(uiColor: K.Colors.properBlack).clipShape(RoundedRectangle(cornerRadius: 10))
            Color.red.clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                HStack {
                    Image(systemName: "xmark")
                    Spacer()
                    Text("\(tempSelection.rawValue)")
                    Spacer()
                }
                .font(.title)
                
                List {
        
                    Picker(selection: $tempSelection) {
                        ForEach(Temps.allCases, id: \.self) { i in
                            Text(i.rawValue).tag(i)
                        }
                    } label: {
                        Label("Temperature Units", systemImage: "thermometer")
                    }
                    
                    
                    
                    Picker(selection: $distanceSelection) {
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
    }
}
