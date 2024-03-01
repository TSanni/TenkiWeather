//
//  SavedLocationImageView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct SavedLocationImageView: View {
    let imageName: String
    let weatherViewModel = WeatherViewModel.shared
    
    var body: some View {
        Circle()
            .fill(Color(uiColor: K.ColorsConstants.prussianBlue))
            .overlay {
                Image(systemName: weatherViewModel.getImage(imageName: imageName))
                    .renderingMode(.original)
                    .padding()
                    .font(.headline)
            }
            .frame(width: 40)
    }
}

#Preview {
    ZStack {
        Color(uiColor: K.ColorsConstants.properBlack)
        SavedLocationImageView(imageName: "cloud.moon.rain")
    }
}
