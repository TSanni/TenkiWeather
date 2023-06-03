//
//  TomorrowScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct TomorrowScreen: View {
    var body: some View {
        VStack {
            Text("Tomorrow")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}

struct TomorrowScreen_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowScreen()
    }
}
