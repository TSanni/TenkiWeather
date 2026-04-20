//
//  SunView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 4/16/26.
//

import SwiftUI

struct SunView: View {
    let frame: CGFloat
    var body: some View {
            ZStack {
//                Rectangle()
//                    .fill(Gradient(colors: [.yellow, .orange]))
//                    .frame(width: frame / 1.2, height: frame / 1.2)
//                    .rotationEffect(Angle(degrees: 45))
//                
//                Rectangle()
//                    .fill(Gradient(colors: [.yellow, .orange]))
//                    .frame(width: frame / 1.2, height: frame / 1.2)
//                    .rotationEffect(Angle(degrees: 90))
                
                Circle()
                    .fill(Gradient(colors: [.yellow, .orange]))
                    .frame(width: frame, height: frame)
            }
            .shadow(color: .white, radius: 2)
            .opacity(1)
    }
}

#Preview {
    ZStack {
        Color.tenDayBarColor.ignoresSafeArea()
        SunView(frame: 100)
    }
}
