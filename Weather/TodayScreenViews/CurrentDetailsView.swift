//
//  CurrentDetailsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/2/23.
//

import SwiftUI

struct CurrentDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(alignment: .leading) {
            Text("Current details")
                .bold()
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("Humidity")
                    Text("Dew point")
                    Text("Pressure")
                    Text("UV index")
                    Text("Visibility")
                }
                .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5.0) {
                    Text("77%")
                    Text("77°F")
                    Text("77 inHg")
                    Text("Extreme, 77")
                    Text("77 mi")

                }
                
                Spacer()
            }
        }
        .padding()
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))
    }
}

struct CurrentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentDetailsView()
    }
}
