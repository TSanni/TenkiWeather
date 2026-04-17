//
//  NoInternetView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/15/26.
//

import SwiftUI

struct NoInternetView: View {
    @EnvironmentObject var networkManager: NetworkMonitor
    
    var body: some View {
        if !networkManager.isConnected {
            HStack {
                Image(systemName: "wifi.slash")
                Text("No Internet Connection")
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    ZStack {
        Color.tenDayBarColor.ignoresSafeArea()
        NoInternetView()
            .environmentObject(NetworkMonitor.preview)
    }
    
}
