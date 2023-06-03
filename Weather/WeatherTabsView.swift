//
//  WeatherTabsView.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

enum WeatherTabs {
    case today
    case tomorrow
    case multiDay
}

struct WeatherTabsView: View {
    
    @Namespace var underline
    @Binding var weatherTab: WeatherTabs
    
    var body: some View {
        HStack {
            VStack {
                Text("Today")
                    .onTapGesture {
                        withAnimation {
                            weatherTab = .today
                        }
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                        .frame(height: 2)
                    if weatherTab == .today {
                        RoundedRectangle(cornerRadius: 10)
                            .matchedGeometryEffect(id: "selected", in: underline)
                            .frame(height: 2)
                            .frame(width: 70)
                    }
                }
            }
            Spacer()
            VStack {
                Text("Tomorrow")
                    .onTapGesture {
                        withAnimation {
                            weatherTab = .tomorrow
                        }
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                        .frame(height: 2)
                    if weatherTab == .tomorrow {
                        RoundedRectangle(cornerRadius: 10)
                            .matchedGeometryEffect(id: "selected", in: underline)
                            .frame(height: 2)
                            .frame(width: 70)
                    }
                }
            }
            Spacer()
            VStack {
                Text("10 days")
                    .onTapGesture {
                        withAnimation {
                            weatherTab = .multiDay
                        }
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                        .frame(height: 2)
                    if weatherTab == .multiDay {
                        RoundedRectangle(cornerRadius: 10)
                            .matchedGeometryEffect(id: "selected", in: underline)
                            .frame(height: 2)
                            .frame(width: 70)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .padding([.horizontal])
    }
}

struct SwiftUIView2_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTabsView(weatherTab: .constant(.today))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
    }
}
