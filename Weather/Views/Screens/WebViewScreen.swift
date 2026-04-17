//
//  FullScreenWebview.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/18/23.
//

import SwiftUI

struct FullScreenWebview: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let url: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            }

            WebView(urlString: url)
        }
        .background(colorScheme == .light ? Color.goodLightTheme : Color.goodDarkTheme)

    }


}

#Preview {
    FullScreenWebview(url: "https://www.google.com")
}
