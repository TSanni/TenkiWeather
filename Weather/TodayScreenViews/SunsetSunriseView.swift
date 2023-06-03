//
//  SunsetSunriseView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI

struct SunsetSunriseView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text("Sunrise & Sunset")
                .bold()
                .padding(.vertical)
            
            HStack {
                VStack(spacing: 5.0) {
                    Text("Sunrise").foregroundColor(.secondary)
                    Text("7:77 AM").font(.title)
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Sunset").foregroundColor(.secondary)
                    Text("7:77 PM").font(.title)
                }
            }
            
            Image(systemName: "sun.max")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                VStack(spacing: 5.0) {
                    Text("Dawn").foregroundColor(.secondary)
                    Text("7:77 AM")
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Solar noon").foregroundColor(.secondary)
                    Text("7:77 AM")
                }
                Spacer()
                VStack(spacing: 5.0) {
                    Text("Dusk").foregroundColor(.secondary)
                    Text("7:77 AM")
                }
                
            }
            
            VStack(alignment: .leading, spacing: 10.0) {
                HStack {
                    Text("Length of day").foregroundColor(.secondary)
                    Text("17h 77m")
                }
                
                HStack {
                    Text("Remaining daylight").foregroundColor(.secondary)
                    Text("17h 77m")
                }
            }
        }
        .padding()
        .padding(.bottom)
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

    }
}

struct SunsetSunriseView_Previews: PreviewProvider {
    static var previews: some View {
        SunsetSunriseView()
    }
}
