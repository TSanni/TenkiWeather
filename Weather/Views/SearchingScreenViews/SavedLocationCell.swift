//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    @ObservedObject var location: LocationEntity
    
    var body: some View {
        ZStack {
            Color.teal.opacity(0.000001)
            HStack {
                SavedLocationImageView(imageName: location.sfSymbol ?? "")
                
                VStack(alignment: .leading) {
                    Text(location.name ?? "no name")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 0.0) {
                        Text((location.temperature ?? "") + "°")
                        Text(" • ")
                        Text(location.weatherCondition ?? "")
                    }
                    .font(.subheadline)
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
}

//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(location: TodayWeatherModel.holderData)
//    }
//}
