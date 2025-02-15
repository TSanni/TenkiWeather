//
//  RainScene.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/5/24.
//

import Foundation
import SpriteKit


// radians = degrees * .pi / 180

// degrees = rad * 180 / .pi

class RainScene: SKScene {

    let rainEmitterNode = SKEmitterNode(fileNamed: "rain.sks")

    override func didMove(to view: SKView) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particleSize = CGSize(width: 100, height: 100)
        rainEmitterNode.emissionAngle = 270 * (.pi/180)
        rainEmitterNode.particleBirthRate = 100
        rainEmitterNode.position = CGPoint(x: 0, y: 100)
        
        addChild(rainEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        rainEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
    
}
