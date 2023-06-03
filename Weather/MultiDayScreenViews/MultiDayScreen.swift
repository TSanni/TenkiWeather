//
//  MultiDayScreen.swift
//  Weather
//
//  Created by Tomas Sanni on 5/29/23.
//

import SwiftUI

struct MultiDayScreen: View {
    var body: some View {
        VStack {
            Text("10 days")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple)
    }
}

struct MultiDayScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiDayScreen()
    }
}
