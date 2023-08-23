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
    @Namespace var namespace
    

    var body: some View {
            HStack {
                ForEach(WeatherTabs.allCases, id: \.self) { tab in
                    Button {
                            weatherTab = tab
                    } label: {
                        VStack {
                            Text(tab.rawValue)
                                
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                                    .frame(height: 2)
                                if weatherTab == tab {
                                    RoundedRectangle(cornerRadius: 10)
                                        .matchedGeometryEffect(id: "selected", in: namespace, properties: .frame)
                                        .frame(height: 3)
                                        .frame(width: 70)
                                }
                            }
                        }
                    }
                    .tint(.white)
                }
            }
    }
}

struct WeatherTabSelectionsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTabSelectionsView(weatherTab: .constant(.today))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
    }
}
