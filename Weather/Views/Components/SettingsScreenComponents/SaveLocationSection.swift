//
//  SaveLocationSection.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/18/26.
//

import SwiftUI

struct SaveLocationSection: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        Section("Save Location") {
            Button {
                appStateViewModel.saveLocation()
            } label: {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.title)
                    
                    Spacer()
                    
                    VStack {
                        Text(appStateViewModel.searchedLocationModel.name)
                            .foregroundStyle(.green)
                        
                        Text("Click to save this location")
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                    }
                    
                    Spacer()
                }
            }
            .tint(.primary)
        }
    }
}

#Preview {
    SaveLocationSection()
}
