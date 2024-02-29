//
//  SearchBar.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStateManager: AppStateManager
    @EnvironmentObject var locationManager: CoreLocationViewModel
    var body: some View {
        
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                Text(locationManager.searchedLocationName)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                            appStateManager.showSettingScreen = true
                    }
            

            }

            .padding()
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 1).fill(Color.white).frame(height: 50)
                    RoundedRectangle(cornerRadius: 5).fill(colorScheme == .light ? K.ColorsConstants.goodLightTheme : K.ColorsConstants.goodDarkTheme)
                        .frame(height: 50)
                }
            }
            .padding()

    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.indigo
            SearchBar()
                .environmentObject(CoreLocationViewModel.shared)
                .environmentObject(AppStateManager.shared)

        }
        
    }
}
