//
//  FullScreenWebView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/18/23.
//

import SwiftUI

struct FullScreenWebView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let url: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .contentShape(Rectangle())
            }

            WebView(urlString: url)
        }
        .background(colorScheme == .light ? K.Colors.goodLightTheme : K.Colors.goodDarkTheme)

    }


}

struct FullScreenWebView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenWebView(url: "https://www.google.com")
    }
}
