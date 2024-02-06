//
//  RainScene.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/5/24.
//

import Foundation
import SpriteKit


class RainScene: SKScene {

    let rainEmitterNode = SKEmitterNode(fileNamed: "rain.sks")
//    let ball = SKSpriteNode(imageNamed: "dodgeBall")

    override func didMove(to view: SKView) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particleSize = CGSize(width: 100, height: 100)

//        rainEmitterNode.particleColorSequence = nil;
//        rainEmitterNode.particleColorBlendFactor = 1.0;
//        rainEmitterNode.particleColor = UIColor.white
        rainEmitterNode.emissionAngle = 4.71239
        rainEmitterNode.particleBirthRate = 100
        
//        rainEmitterNode.particleLifetime = 2
//        rainEmitterNode.particleLifetimeRange = 6
        addChild(rainEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        rainEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
    
}
