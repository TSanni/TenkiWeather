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
    
    @Namespace var namespace
    @EnvironmentObject var appStateManager: AppStateManager
    
    
    var body: some View {
        HStack {
            ForEach(WeatherTabs.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.default) {
                        appStateManager.weatherTab = tab
                    }
                    
                } label: {
                    VStack {
                        Text(tab.rawValue)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                                .frame(height: 2)
                            if appStateManager.weatherTab == tab {
                                RoundedRectangle(cornerRadius: 10)
                                    .matchedGeometryEffect(id: "selected", in: namespace, properties: .frame)
                                    .frame(height: 3)
                                    .frame(width: 50)
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
        WeatherTabSelectionsView()
            .environmentObject(AppStateManager())
            .previewDevice("iPhone 11 Pro Max")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
    }
}
