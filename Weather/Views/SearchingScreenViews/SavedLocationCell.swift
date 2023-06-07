//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
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
                            
                            Text("July 7, 7:77 PM")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack(alignment: .top, spacing: 0.0) {
                                Text("77").font(.title)
                                Text("°F")
                            }
                            .foregroundColor(.secondary)
                            
                            Image(systemName: "cloud.rain.fill")
                        }
                    }
                }
            }
            
            CustomDivider()
        }
    }
}

struct SavedLocationCell_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocationCell()
    }
}
