//
//  GameProcessingView.swift
//  HorseRace
//
//  Created by DongKyu Kim on 2022/08/22.
//

import SwiftUI
import SpriteKit

struct GameProcessingView: View {
    var body: some View {
        ZStack {
            SpriteView(scene: HorseRunningScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
                .ignoresSafeArea()
        }
    }
}

class HorseRunningScene: SKScene {
    
    let backgroundStart = SKSpriteNode(imageNamed: "backgroundStart")
    let backgroundMiddle = SKSpriteNode(imageNamed: "backgroundMiddle")
    
    private var horse = SKSpriteNode()
    private var horseRunningFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        backgroundStart.anchorPoint = CGPoint.zero
        backgroundStart.position = CGPoint.zero
        backgroundStart.zPosition = -10
        addChild(backgroundStart)
        
        backgroundMiddle.anchorPoint = CGPoint.zero
        backgroundMiddle.position.x = backgroundStart.size.width
        backgroundMiddle.position.y = 0
        backgroundMiddle.zPosition = -10
        addChild(backgroundMiddle)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        backgroundStart.position.x -= 10
        backgroundMiddle.position.x -= 10
        
        if backgroundMiddle.position.x + backgroundMiddle.size.width < UIScreen.main.bounds.size.width {
            // backgroundStart 뒷부분 다시 활용
            backgroundStart.position.x = backgroundMiddle.position.x
            backgroundMiddle.position.x += backgroundMiddle.size.width
        }
    }
}
