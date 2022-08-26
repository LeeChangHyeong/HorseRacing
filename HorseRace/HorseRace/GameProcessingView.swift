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
        
        buildHorse(color: "red")
        animateHorse(color: "red", speed: 10)

        buildHorse(color: "green")
        animateHorse(color: "green", speed: 20)

        buildHorse(color: "blue")
        animateHorse(color: "blue", speed: 30)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        backgroundStart.position.x -= 10
        backgroundMiddle.position.x -= 10
        
        if backgroundMiddle.position.x + backgroundMiddle.size.width < UIScreen.main.bounds.size.width {
            // backgroundStart 뒷부분 다시 활용
            backgroundStart.position.x = backgroundMiddle.position.x
            backgroundMiddle.position.x += backgroundMiddle.size.width
        }
        
        horse.position.x += CGFloat.random(in: -5...10)
    }
    
    
    func buildHorse(color: String) {
        // horse Atlas를 생성, 여기서는 sample Red 이미지로 구성
        // 말이 여러 마리일 경우 prameter로 말 색상 줄 수 있음 -> let horseColor: String
        // position 변경 -> horse.position = CGPoint(x:y:) 임의로 설정해 둔 상태
        
        let horseAnimatedAtlas = SKTextureAtlas(named: "\(color)HorseImages")
        var runFrames: [SKTexture] = []
        
        let numImages = horseAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let horseTextureName = "\(color)Horse\(i)"
            runFrames.append(horseAnimatedAtlas.textureNamed(horseTextureName))
        }
        horseRunningFrames = runFrames
        
        let firstFrameTexture = horseRunningFrames[0]
        horse = SKSpriteNode(texture: firstFrameTexture)
        horse.position = CGPoint(x: frame.minX + 100, y: frame.midY + 100 * CGFloat.random(in: -1...1))
        horse.size = CGSize(width: 188, height: 106)
        addChild(horse)
        
    }
    
    
    func animateHorse(color: String, speed: Double) {
        // horse 애니메이션 동작, speed는 말의 다리 움직임 속도(필요한 부분인지는 잘 모르겠음)
        let timePerFrame = 1 / speed
        
        horse.run(SKAction.repeatForever(
            SKAction.animate(with: horseRunningFrames,
                             timePerFrame: timePerFrame,
                             resize: false,
                             restore: true)),
        withKey: "\(color)HorseRunning")
    }
    
}
