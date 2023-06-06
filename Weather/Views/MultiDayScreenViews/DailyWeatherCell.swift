//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct DailyWeatherCell: View {
    @State private var showRest: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Color.teal.opacity(0.000001)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Today")
                                .foregroundColor(.primary)
                                .font(.headline)
                            
                            Text("Scattered thunderstorms")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack {
                                Text("40%")
                                    .foregroundColor(.teal)
                                
                                Image(systemName: "cloud.rain.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                            
                            VStack {
                                Text("77°")
                                    .foregroundColor(.primary)
                                
                                Text("77°")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onTapGesture {
                      withAnimation(.linear(duration: 0.2)) {
                          showRest.toggle()
                      }
                  }
                
                
                if showRest {
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Wind")
                            Text("Humidity")
                            Text("UV index")
                            Text("Chance of rain")
                            Text("Sunrise/sunset")
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text("Light, 7 mph E")
                            Text("77%")
                            Text("Very high, 77")
                            Text("77%")
                            Text("7:77 AM, 7:77 PM")
                        }
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                    }
                    .padding(.bottom)
                    .transition(.identity)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<20) { item in
                                VStack {
                                    Text("77°")
                                    Image(systemName: "moon.fill")
                                    Text("7 PM")
                                }
                            }
                        }
                    }
                    .transition(.identity)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            
            CustomDivider()
        }

    }
}

struct DailyWeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherCell()
    }
}
