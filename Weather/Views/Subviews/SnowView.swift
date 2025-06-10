//
//  SnowView.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/9/25.
//

import Foundation
import SwiftUI

struct SnowView: UIViewRepresentable {
    let snowBirthRate: Float
    let snowVelocity: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let snow = CAEmitterLayer()
        snow.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        snow.emitterShape = .line
        snow.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)

        let snowflake = CAEmitterCell()
        snowflake.contents = UIImage(named: "snowflake")?.cgImage
        snowflake.color = UIColor.white.cgColor
        snowflake.birthRate = snowBirthRate
        snowflake.lifetime = 10
        snowflake.velocity = snowVelocity
        snowflake.velocityRange = 0
        snowflake.emissionLongitude = .pi // 👈 Starts falling straight down
        snowflake.emissionRange = .pi / 8     // 👈 Slight random angle for realism
        snowflake.scale = 0.015

        snow.emitterCells = [snowflake]
        view.layer.addSublayer(snow)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
