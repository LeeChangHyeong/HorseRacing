//
//  EndParticles.swift
//  HorseRace
//
//  Created by DongKyu Kim on 2022/09/15.
//
import SwiftUI
import SpriteKit

class EndParticlesScene: SKScene {
    var emitter: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        let shortWait = SKAction.wait(forDuration: 0.3)
        let longWait = SKAction.wait(forDuration: 2.5)
        let showParticle = SKAction.run { [self] in
            self.emitter = SKEmitterNode(fileNamed: "endParticle")
            self.emitter.position = CGPoint(x: Int(self.frame.width) / 10 * Int.random(in: 1...9) , y: Int(self.frame.height) / 4 * Int.random(in: 1...3))
            self.addChild(self.emitter)
        }
        
        let shortSequence = SKAction.repeat(SKAction.sequence([showParticle, shortWait]), count: 5)
        
        run(SKAction.repeatForever(SKAction.sequence([shortSequence, longWait])))
    }

}
