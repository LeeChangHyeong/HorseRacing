//
//  GameProcessingView.swift
//  HorseRace
//
//  Created by DongKyu Kim on 2022/08/22.
//

import SwiftUI
import SpriteKit

struct GameProcessingView: View {
    @State private var start: Bool = false
    @State private var count = 3
    
    var body: some View {
        
        ZStack {
            SpriteView(scene: HorseRunningScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
                .ignoresSafeArea()
            
            if count > 0 {
                numView
            } else if count == 0{
                startMessage
            }
        }
    }
    
    // 우선은 onAppear, onChange에 asyncAfter를 활용했는데, Timer를 직접 활용하는게 나을 수도 있을 것 같습니다
    private var numView: some View {
        Text("\(count)")
            .font(.custom("Copperplate", size: 120))
            .foregroundColor(.white)
            .onAppear {
                countDown()
            }
            .onChange(of: count) { _ in
                countDown()
            }
    }
    
    private var startMessage: some View {
        Text("Start!")
            .font(.custom("Copperplate", size: 80))
            .foregroundColor(.white)
            .onAppear {
                countDown()
            }
    }
    
    private func countDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut) {
                count -= 1
            }
        }
    }
}


// MARK: Horse Running Animation SpriteKit Scene
class HorseRunningScene: SKScene {
    
    let backgroundStart = SKSpriteNode(imageNamed: "backgroundStart")
    let backgroundMiddle = SKSpriteNode(imageNamed: "backgroundMiddle")
    
    let horseCount: Int = 6// 말 마리 수 받아오기
    
    private var colorArray: [String] = ["red", "green", "blue", "red2", "green2", "blue2"]
    private var horse: [String: SKSpriteNode] = [:]
    private var horseRunningFrames: [SKTexture] = []
    
    private var start = false
    
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
        
        colorArray.shuffle()
        
        for i in 1...horseCount {
            buildHorse(color: colorArray[i-1])
        }
        
        print("\(horseCount) horses")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let backgroundSpeed: CGFloat = 10
        
        if start {
            backgroundStart.position.x -= backgroundSpeed
            backgroundMiddle.position.x -= backgroundSpeed
            
            if backgroundMiddle.position.x + backgroundMiddle.size.width < UIScreen.main.bounds.size.width {
                // backgroundStart 뒷부분 다시 활용
                backgroundStart.position.x = backgroundMiddle.position.x
                backgroundMiddle.position.x += backgroundMiddle.size.width
            }
            
            for horseColor in horse.keys {
                horse[horseColor]?.position.x += CGFloat.random(in: -2...3)
            }
        }
    }
    
    
    // horse Atlas를 생성
    func buildHorse(color: String) {
        // 말이 여러 마리일 경우 prameter로 말 색상 주기 (color)
        // position 변경 -> horse.position = CGPoint(x:y:) 임의로 설정해 둔 상태
        
        let horseAnimatedAtlas = SKTextureAtlas(named: "\(color)HorseImages")
        var runFrames: [SKTexture] = []
        
        let numImages = horseAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let horseTextureName = "\(color)Horse\(i)"
            runFrames.append(horseAnimatedAtlas.textureNamed(horseTextureName))
        }
        horseRunningFrames = runFrames
        
        let firstFrameTexture = horseRunningFrames[4]
        horse[color] = SKSpriteNode(texture: firstFrameTexture)
        
        if let horseNode = horse[color] {
            horseNode.position = CGPoint(x: frame.minX + 180, y: UIScreen.main.bounds.height / CGFloat((horseCount) + 1) * CGFloat((colorArray.firstIndex(of: color)!) + 1) - CGFloat(40))
            horseNode.zPosition = -CGFloat(colorArray.firstIndex(of: color)!)  // 위에 있는 말이 뒤로 가도록 zPosition 지정 필요
            horseNode.size = CGSize(width: 188, height: 106)
            addChild(horseNode)
            
            // 3초 이후 배경 및 horse 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.start = true
            }
            
            animateHorse(color: color, speed: 30)
        }
    }
    
    
    // horse 다리 애니메이션 동작, speed는 말의 다리 움직임 속도(
    func animateHorse(color: String, speed: Double) {
        let timePerFrame = 1 / speed
        
        // 3초간 대기하는 Action
        let waiting = SKAction.wait(forDuration: 3)
        
        
        // 달리는 Action
        let runningAction = SKAction.repeatForever(SKAction.animate(with: horseRunningFrames,timePerFrame: timePerFrame)
        )
        
        // 앞의 두 Action을 순서대로 수행
        if let horseNode = horse[color] {
            horseNode.run(SKAction.sequence([waiting, runningAction]),
                          withKey: "\(color)HorseRunning"
            )
        }
    }
    
}
