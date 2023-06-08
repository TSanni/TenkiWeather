//
//  SearchBar.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                Text("Rosenberg, Tx 77471")
                    .foregroundColor(.primary)
                
                Spacer()
//                Circle().fill(Color.gray)
//                    .frame(width: 30)
            }
            .padding()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).fill(Color.white).frame(height: 50)
                    RoundedRectangle(cornerRadius: 5).fill(colorScheme == .light ? .white : Color(red: 0.15, green: 0.15, blue: 0.15) )
                        .frame(height: 50)
                }
            }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo
            SearchBar()
        }
        
    }
}
