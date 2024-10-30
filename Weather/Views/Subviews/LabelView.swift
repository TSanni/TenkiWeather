//
//  LabelView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 7/18/23.
//

import SwiftUI

struct LabelView: View {
    var title: String
    let iconSymbol: String
    
    var body: some View {
        Label {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        } icon: {
            Image(systemName: iconSymbol)
        }
        
    }
}

#Preview {
    LabelView(title: "My title", iconSymbol: "sun.min")

}
