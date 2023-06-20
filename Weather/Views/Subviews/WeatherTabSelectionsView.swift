//
//  WeatherTabSelectionsView.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

enum WeatherTabs: String, CaseIterable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case multiDay = "10 Days"
}

struct WeatherTabSelectionsView: View {
    
    @Binding var weatherTab: WeatherTabs
    @Namespace var underline

    var body: some View {
        HStack {
//            Spacer()
            ForEach(WeatherTabs.allCases, id: \.self) { tab in
                Button {
                    withAnimation {
                        weatherTab = tab
                    }
                } label: {
                    VStack {
                        Text(tab.rawValue)
                            
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                                .frame(height: 2)
                            if weatherTab == tab {
                                RoundedRectangle(cornerRadius: 10)
                                    .matchedGeometryEffect(id: "selected", in: underline)
                                    .frame(height: 3)
                                    .frame(width: 70)
                            }
                        }
                    }
                }
                .tint(.white)
//                Spacer()

            }
        }
        
        
        
        
        
        
//        HStack {
//            VStack {
//                Text("Today")
//                    .onTapGesture {
//                        withAnimation {
//                            weatherTab = .today
//                        }
//                    }
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
//                        .frame(height: 2)
//                    if weatherTab == .today {
//                        RoundedRectangle(cornerRadius: 10)
//                            .matchedGeometryEffect(id: "selected", in: underline)
//                            .frame(height: 3)
//                            .frame(width: 70)
//                    }
//                }
//            }
//            Spacer()
//            VStack {
//                Text("Tomorrow")
//                    .onTapGesture {
//                        withAnimation {
//                            weatherTab = .tomorrow
//                        }
//                    }
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
//                        .frame(height: 2)
//                    if weatherTab == .tomorrow {
//                        RoundedRectangle(cornerRadius: 10)
//                            .matchedGeometryEffect(id: "selected", in: underline)
//                            .frame(height: 3)
//                            .frame(width: 70)
//                    }
//                }
//            }
//            Spacer()
//            VStack {
//                Text("10 days")
//                    .onTapGesture {
//                        withAnimation {
//                            weatherTab = .multiDay
//                        }
//                    }
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
//                        .frame(height: 2)
//                    if weatherTab == .multiDay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .matchedGeometryEffect(id: "selected", in: underline)
//                            .frame(height: 3)
//                            .frame(width: 70)
//                    }
//                }
//            }
//        }
//        .foregroundColor(.white)
    }
}

struct WeatherTabSelectionsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTabSelectionsView(weatherTab: .constant(.today))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
    }
}
