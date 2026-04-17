//
//  ToolbarItemView.swift
//  Weather
//
//  Created by Tomas Sanni on 4/17/26.
//
import SwiftUI

struct ToolbarItemViewModififer: ViewModifier {
    @EnvironmentObject var locationViewModel: CoreLocationViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text(locationViewModel.searchedLocationName)
                        }
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture { appStateViewModel.toggleShowSearchScreen() }
                        
                        Spacer()
                        Divider()
                        
                        Image(systemName: "gear")
                            .padding()
                            .contentShape(Rectangle())
                            .onTapGesture { appStateViewModel.toggleShowSettingScreen() }
                    }
                }
            }
    }
}



