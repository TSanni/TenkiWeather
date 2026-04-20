//
//  SavedLocationImageView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/25/24.
//

import SwiftUI

struct SavedLocationImageView: View {
    let imageName: String
    
    var body: some View {
        Circle()
            .fill(Color.prussianBlue)
            .overlay {
                Image(systemName: Helper.getImage(imageName: imageName))
                    .renderingMode(.original)
                    .padding()
                    .font(.headline)
            }
            .frame(width: 40)
    }
}

#Preview {
    ZStack {
        SavedLocationImageView(imageName: "cloud.moon.rain")
    }
}
