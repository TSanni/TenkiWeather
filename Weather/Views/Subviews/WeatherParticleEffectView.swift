//
//  WeatherParticleEffectView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/5/24.
//

import SwiftUI
import SpriteKit

struct WeatherParticleEffectView: View {
    let sceneImport: SKScene
    
    var scene: SKScene {
        let scene = sceneImport
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }
    
    
    var body: some View {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .allowsHitTesting(false)
    }
}

#Preview {
    WeatherParticleEffectView(sceneImport: SnowScene())
}
