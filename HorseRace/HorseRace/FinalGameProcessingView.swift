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
    private var horseArr: [SKSpriteNode] = [SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode(),SKSpriteNode()]
    private var randomSecond: [Int] = []
//    private var horse = SKSpriteNode()
//    private var horse2 = SKSpriteNode()
//    private var horse3 = SKSpriteNode()
    
    private var horseRunningFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        // 배경 크기 조절
        backgroundFinish.anchorPoint = CGPoint.zero
        backgroundFinish.size.width = UIScreen.main.bounds.size.width
        backgroundFinish.size.height = UIScreen.main.bounds.size.height
        addChild(backgroundFinish)
        
        // 받아온 변수로 바꾸기 ( 0..< 받아온 플레이어 수 )
        (0..<6).forEach { item in
            var color: String = ""
            switch item {
            case 0:
                color = "red"
                randomSecond.append((60...180).randomElement() ?? 60 )
            case 1:
                color = "green"
                randomSecond.append((60...180).randomElement() ?? 60 )
            case 2:
                color = "blue"
                randomSecond.append((60...180).randomElement() ?? 60 )
            default:
                // case 3 ~ case 5 색상 지정 해주기
                color = "blue"
                randomSecond.append((60...180).randomElement() ?? 60 )
            }
            buildHorse(color: color, horse: horseArr[item])
            animateHorse(color: color, speed: 50, horse: horseArr[item])
        }
//        buildHorse(color: "red", horse: horse)
//        animateHorse(color: "red", speed: 50, horse: horse)
//
//        buildHorse(color: "green", horse: horse2)
//        animateHorse(color: "green", speed: 50, horse: horse2)
//
//        buildHorse(color: "blue", horse: horse3)
//        animateHorse(color: "blue", speed: 50, horse: horse3)
        
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        // 60에서 180사이
        
        // 받아온 변수로 바꾸기
        (0..<6).forEach { item in
            horseArr[item].position.x += CGFloat(UIScreen.main.bounds.size.width / CGFloat(randomSecond[item]))
        }
//        horse.position.x += CGFloat(UIScreen.main.bounds.size.width / 180)
//        horse2.position.x += CGFloat(UIScreen.main.bounds.size.width / 130)
//        horse3.position.x += CGFloat(UIScreen.main.bounds.size.width / 120)
    }
    
    
    func buildHorse(color: String, horse: SKSpriteNode) {
        // horse Atlas를 생성, 여기서는 sample Red 이미지로 구성
        // 말이 여러 마리일 경우 prameter로 말 색상 줄 수 있음 -> let horseColor: String
        // position 변경 -> horse.position = CGPoint(x:y:) 임의로 설정해 둔 상태
        
        let horseAnimatedAtlas = SKTextureAtlas(named: "\(color)HorseImages")
        var runFrames: [SKTexture] = []
        
        // 받아온 변수로 대체, ( 현재 임시 변수 )
        let num = 6
        
        let numImages = horseAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let horseTextureName = "\(color)Horse\(i)"
            runFrames.append(horseAnimatedAtlas.textureNamed(horseTextureName))
        }
        horseRunningFrames = runFrames
        
//        (0..<3).forEach { item in
//            horseArr[item].position = CGPoint(x: frame.minX - 10, y: (UIScreen.main.bounds.height / (num + 1)) * (item + 1) - 100)
//        }
        
        for i in 0..<num {
            horseArr[i].position = CGPoint(x: frame.minX - 10, y: UIScreen.main.bounds.height / CGFloat((num + 1)) * CGFloat((i + 1)) - CGFloat(40))
        }
        
                                            //(UIScreen.main.bounds.height / (num + 1)) * (i + 1) - 100))
//        if horse === self.horseArr[0] {
//            horse.position = CGPoint(x: frame.minX - 10, y: frame.midY + 20)
//        } else if horse === self.horseArr[1]{
//            horse.position = CGPoint(x: frame.minX - 10, y: frame.midY)
//        }
        horse.size = CGSize(width: 188, height: 106)
        addChild(horse)
        
    }
    
    
    func animateHorse(color: String, speed: Double, horse: SKSpriteNode) {
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
