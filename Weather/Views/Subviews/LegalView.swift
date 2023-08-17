//
//  LegalView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/17/23.
//

import SwiftUI

struct LegalView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 10.0) {
            Text(" Weather")
                .foregroundColor(.primary)
                .font(.headline)
            
            NavigationLink {
                WebView(urlString: "https://weatherkit.apple.com/legal-attribution.html")
            } label: {
                Group {
                    Text("Learn more about ")
                    + Text("weather sources").underline()
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)

        
    }
}


struct LegalView_Previews: PreviewProvider {
    static var previews: some View {
        LegalView()
    }
}
