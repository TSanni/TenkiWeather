//
//  SavedLocationsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationsView: View {
    @EnvironmentObject var persistence: SavedLocationsPersistenceViewModel
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        List {
            if persistence.savedLocations.count == 0 {
                Text("")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            ForEach(persistence.savedLocations, id: \.self) { item in
                SavedLocationCell(location: item)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)
                    .padding(.top)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Task {
                            await appStateViewModel.getWeatherAndUpdateDictionaryFromSavedLocation(item: item)
                            persistence.saveData()
                        }
                    }
            }
            .onDelete(perform: persistence.deletePlace(indexSet:))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    ZStack {
        K.ColorsConstants.goodDarkTheme
        SavedLocationsView()
            .environmentObject(SavedLocationsPersistenceViewModel.shared)
            .environmentObject(AppStateViewModel.shared)
    }
}
