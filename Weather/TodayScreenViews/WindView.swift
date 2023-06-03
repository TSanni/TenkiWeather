//
//  WindView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/3/23.
//

import SwiftUI

struct WindView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Wind")
                .bold()
            
            HStack {
                Text("7")
                    .bold()
                    .font(.system(size: 70))
                    .foregroundColor(.blue)
                
                VStack {
                    Image(systemName: "location.fill")
                    Text("mph")
                }
                
                VStack(alignment: .leading) {
                    Text("Light")
                        .font(.system(size: 45, weight: .light))
                    Text("Now · From south")
                }
            }
            
            WindBarGraph()
            
        }
        .padding()
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

    }
}

struct WindView_Previews: PreviewProvider {
    static var previews: some View {
        WindView()
    }
}
