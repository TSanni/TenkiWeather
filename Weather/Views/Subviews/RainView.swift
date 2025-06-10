//
//  RainView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/9/25.
//

import Foundation
import SwiftUI

struct RainView: UIViewRepresentable {
    let rainBirthRate: Float
    let rainVelocity: CGFloat
    
    let cloudBirthRate: Float
    let cloudVelocity: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let rainEmitter = CAEmitterLayer()
        rainEmitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 10)
        rainEmitter.emitterShape = .line
        rainEmitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        rainEmitter.opacity = 0.15
        
        let raindrop = CAEmitterCell()
        raindrop.contents = UIImage(named: "raindrop-removebg")?.cgImage
        raindrop.color = UIColor.white.cgColor
        raindrop.birthRate = rainBirthRate
        raindrop.lifetime = 10
        raindrop.velocity = rainVelocity
        raindrop.velocityRange = 0
        raindrop.emissionLongitude = .pi // 👈 Starts falling straight down
        raindrop.yAcceleration = 30
//        raindrop.emissionRange = .pi / 8     // 👈 Slight random angle for realism
        raindrop.scale = 0.03
        raindrop.scaleRange = 0.02
        
        
        let cloudEmitter = CAEmitterLayer()
        cloudEmitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width + 200, y: 0)
        cloudEmitter.emitterShape = .rectangle
        cloudEmitter.emitterSize = CGSize(width: 0, height: 700)
        cloudEmitter.opacity = 0.15

        let cloud = CAEmitterCell()
        cloud.contents = UIImage(named: "cloud")?.cgImage
        cloud.color = UIColor.white.cgColor
        cloud.birthRate = cloudBirthRate // One cloud every 15 seconds
        cloud.velocity = cloudVelocity
        cloud.emissionLongitude = -.pi // ⬅️ Points left
//        cloud.emissionRange = .pi / 8     // 👈 Slight random angle for realism
        cloud.lifetime = 1000 // particle fades out completely in 20s
        cloud.scale = 0.08


        rainEmitter.emitterCells = [raindrop]
        cloudEmitter.emitterCells = [cloud]
        view.layer.addSublayer(rainEmitter)
        view.layer.addSublayer(cloudEmitter)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
