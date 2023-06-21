//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    let location: TodayWeatherModel
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Color.teal.opacity(0.000001)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tokyo, Japan")
                                .foregroundColor(.primary)
                                .font(.headline)
                            
                            Text(location.date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack(alignment: .top, spacing: 0.0) {
                                Text(location.currentTemperature)
                                    .font(.title)
                                Text("°F")
                            }
                            .foregroundColor(.secondary)
                            
                            Image(systemName: WeatherManager.shared.getImage(imageName: location.symbol))
                        }
                    }
                }
            }
            
//            CustomDivider()
        }
    }
}

struct SavedLocationCell_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationCell(location: TodayWeatherModel.holderData)
    }
}
