//
//  CloudView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/9/25.
//

import Foundation
import SwiftUI

struct CloudView: UIViewRepresentable {
    let cloudBirthRate: Float
    let cloudVelocity: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        
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


        cloudEmitter.emitterCells = [cloud]
        view.layer.addSublayer(cloudEmitter)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
