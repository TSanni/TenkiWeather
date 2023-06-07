//
//  SearchingScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SearchingScreen: View {
    @State private var searchText: String = ""
    @FocusState private var focusSearch: Bool
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.0000001)
            
            VStack {
                
                CustomDivider()
                
                    VStack {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Rosenberg, TX 77471")
                                    .font(.headline)
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.blue)
                                    Text("Your location")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            HStack {
                                HStack(alignment: .top, spacing: 0.0) {
                                    Text("77").font(.title)
                                    Text("°F")
                                }
                                .foregroundColor(.secondary)
                                
                                Image(systemName: "sun.max")
                            }
                        }
                        .padding(.bottom)
                        
                        
                        HStack {
                            Text("Saved locations")
                                .font(.headline)
                            Spacer()
                            
//                            Text("MANAGE")
//                                .font(.subheadline)
                        }
                        .foregroundColor(.secondary)
                        
                        CustomDivider()
                        
                        SavedLocationsView()
                    }
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextField(text: $searchText) {
                        Text("Search places")
                    }
                    .focused($focusSearch)
                    .tint(Color(#colorLiteral(red: 0.6047868133, green: 0.6487623453, blue: 1, alpha: 1)))
                }
            }
            .customNavBackButton()
            .navigationBarBackButtonHidden()
            .onAppear {
                focusSearch = true
            }
        }
        .onTapGesture {
            focusSearch = false
        }
        .background(colorScheme == .light ? Color.white : Color(red: 0.15, green: 0.15, blue: 0.15))

        
        
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView {
        SearchingScreen()
        //        }
    }
}
