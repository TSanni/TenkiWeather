//
//  LottieView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/23/25.
//

import SwiftUI
import DotLottie
import DotLottiePlayer

struct LottieView: View {
    let name: String
    var body: some View {
        
        DotLottieAnimation(
            fileName: name,
            config: AnimationConfig(
                autoplay: true,
                loop: true,
                speed: 1,
//                width: 100,
//                height: 100,
                layout: nil
            )
        )
        .view()
        
    }
}

#Preview {
    ZStack {
        Color.indigo
        LottieView(name: "rain")
    }
}
