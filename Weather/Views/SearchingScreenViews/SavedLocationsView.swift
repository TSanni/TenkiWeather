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
                        }
                    }
            }
            .onMove(perform: persistence.moveItem(from:to:))
            .onDelete(perform: persistence.deleteLocationBySwipe(indexSet:))
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    ZStack {
        SavedLocationsView()
            .environmentObject(SavedLocationsPersistenceViewModel.preview)
            .environmentObject(AppStateViewModel.preview)
    }
}
