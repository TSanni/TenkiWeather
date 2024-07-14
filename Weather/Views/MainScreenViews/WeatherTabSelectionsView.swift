//
//  WeatherTabSelectionsView.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI


struct WeatherTabSelectionsView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @Namespace var namespace
    @Binding var tabViews: WeatherTabs
    
    var body: some View {
        HStack {
            ForEach(WeatherTabs.allCases, id: \.rawValue) { tab in
                Button {
                    withAnimation {
                        tabViews = tab
                    }
                } label: {
                    VStack {
                        Text(tab.title)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                                .frame(height: 2)
                            if tabViews == tab {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 3)
                                    .frame(width: 50)
                                    .matchedGeometryEffect(
                                        id: "selected",
                                        in: namespace,
                                        properties: .frame
                                    )
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
        WeatherTabSelectionsView(tabViews: .constant(.today))
            .environmentObject(AppStateViewModel.shared)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.indigo)
    }
}
