//
//  SearchingView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "arrow.left")
                    TextField("Search places", text: $searchText)
                }
            }
            .padding()
            
            CustomDivider()

            VStack {
                HStack {
                    Text("Saved locations")
                        .font(.headline)
                    Spacer()
                    Text("MANAGE")
                        .font(.subheadline)
                }
                
                CustomDivider()
            }
            .padding()
            
        }
        

    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView()
    }
}
