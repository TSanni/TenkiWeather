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
        VStack {
            VStack {
                ZStack {
                    Color.teal.opacity(0.000001)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name ?? "no name")
                                .foregroundColor(.primary)
                                .font(.headline)
                            
                            Text(location.currentDate ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack(alignment: .top, spacing: 0.0) {
                                Text(location.temperature ?? "")
                                    .font(.title)
                                Text("°F")
                            }
                            .foregroundColor(.secondary)
                            
                            Image(systemName: WeatherManager.shared.getImage(imageName: location.sfSymbol ?? ""))
                                .renderingMode(.original)
                        }
                    }
                }
            }
            
//            CustomDivider()
        }
    }
}
//
//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(location: TodayWeatherModel.holderData)
//    }
//}
