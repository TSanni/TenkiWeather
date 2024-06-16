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
                Text("Done")
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            }

            WebView(urlString: url)
        }
        .background(colorScheme == .light ? K.ColorsConstants.goodLightTheme : K.ColorsConstants.goodDarkTheme)

    }


}

struct FullScreenWebView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenWebView(url: "https://www.google.com")
    }
}
