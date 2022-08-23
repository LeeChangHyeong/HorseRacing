//
//  FinalGameProcessingView.swift
//  HorseRace
//
//  Created by LeeChangHyeong on 2022/08/23.
//

import SwiftUI
import SpriteKit

struct FinalGameProcessingView: View {
    var body: some View {
        ZStack {
            SpriteView(scene: FinalHorseRunningScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
                .ignoresSafeArea()
        }
    }
}

class FinalHorseRunningScene: SKScene {
    
    let backgroundFinish = SKSpriteNode(imageNamed: "backgroundFinish")
    
    private var horse = SKSpriteNode()
    private var horseRunningFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        // 배경 크기 조절
        backgroundFinish.anchorPoint = CGPoint.zero
        backgroundFinish.size.width = UIScreen.main.bounds.size.width
        backgroundFinish.size.height = UIScreen.main.bounds.size.height
        addChild(backgroundFinish)
        
    
    }
    
}
