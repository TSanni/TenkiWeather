//
//  SnowScene.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/5/24.
//

import Foundation
import SpriteKit

// radians = degrees * .pi / 180

// degrees = rad * 180 / .pi

class SnowScene: SKScene {

    let snowEmitterNode = SKEmitterNode(fileNamed: "snow.sks")

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleSize = CGSize(width: 50, height: 50)
        snowEmitterNode.particleLifetime = 20
        snowEmitterNode.particleBirthRate = 25
        snowEmitterNode.particleSpeed = 80
        snowEmitterNode.emissionAngle = 270 * (.pi / 180)
        snowEmitterNode.yAcceleration = -10
        snowEmitterNode.position = CGPoint(x: 0, y: 100)


        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        snowEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: 0)
    }
    
}
