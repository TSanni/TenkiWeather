//
//  SnowScene.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/5/24.
//

import Foundation
import SpriteKit


class SnowScene: SKScene {

    let snowEmitterNode = SKEmitterNode(fileNamed: "snow.sks")

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleSize = CGSize(width: 50, height: 50)
        snowEmitterNode.particleLifetime = 20
//        snowEmitterNode.particleLifetimeRange = 1
        snowEmitterNode.particleBirthRate = 25
//        snowEmitterNode.particleAlphaSpeed = -0.2
        snowEmitterNode.position = CGPoint(x: 0, y: 400)

        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        snowEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
    
}
