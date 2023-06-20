//
//  SavedLocationsView.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationsView: View {
    let todayCollection: [TodayWeatherModel]
    @EnvironmentObject var vm: SavedLocationsPersistence
    
    var body: some View {
        List {
            if todayCollection.count == 0 {
                Text("")
                    .listRowBackground(Color.clear)
            }
            ForEach(todayCollection) { item in
                SavedLocationCell(location: item)
                   // .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .listRowBackground(Color.clear)
                
            }
            .onDelete(perform: vm.deleteFruit(indexSet:))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct SavedLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationsView(todayCollection: [TodayWeatherModel.holderData, TodayWeatherModel.holderData, TodayWeatherModel.holderData])
            .environmentObject(SavedLocationsPersistence())
        
    }
}
