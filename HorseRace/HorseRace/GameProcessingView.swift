//
//  GameProcessingView.swift
//  HorseRace
//
//  Created by DongKyu Kim on 2022/08/22.
//

import SwiftUI
import SpriteKit

struct GameProcessingView: View {
    @State private var count = 3
    @State private var horseCount = 6 // 🖐SKScene에 Input으로 줄 말 마리 수(이후 Binding 형태로 수정)
    @State private var animationAmount = -90.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            // 말 마리수 반영해서 Scene 생성
            SpriteView(scene: HorseRunningScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), horseCount: horseCount))
                .ignoresSafeArea()
            
            if count > 0 {
                numView
            } else if count == 0{
                startMessage
            }
        }
    }
    
    private var numView: some View {
        Text("\(count)")
            .font(.custom("Copperplate", size: 120))
            .foregroundColor(.white)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 1.0, y: 0.0, z: 0.01))
            .onAppear {
                withAnimation {
                    animationAmount += 90
                }
            }
            .onReceive(timer) { time in
                countDown()
            }
    }
    
    private var startMessage: some View {
        Text("Start!")
            .font(.custom("Copperplate", size: 80))
            .foregroundColor(.white)
            .onReceive(timer) { time in
                countDown()
            }
    }
    
    private func countDown() {
        animationAmount = -90
        if count < 0 {
            timer.upstream.connect().cancel()
        } else {
            withAnimation {
                count -= 1
                animationAmount += 90
            }
        }
        
    }
}


// MARK: Horse Running Animation SpriteKit Scene
class HorseRunningScene: SKScene {
    
    let backgroundStart = SKSpriteNode(imageNamed: "backgroundStart")
    let backgroundMiddle = SKSpriteNode(imageNamed: "backgroundMiddle")
    
    var horseCount: Int = Int.random(in: 2...6)  // 말 마리 수 받아오기
    
    private var colorArray: [String] = ["red", "green", "blue", "red2", "green2", "blue"]
    private var horseArray: [SKSpriteNode?] = []
    private var horseRunningFrames: [SKTexture] = []
    
    private var start = false
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 말 마리 수를 받아 올 수 있는 initializer
    convenience init(size: CGSize, horseCount: Int) {
        self.init(size: size)
        self.horseCount = horseCount
    }
    
    override func didMove(to view: SKView) {
        backgroundStart.anchorPoint = CGPoint.zero
        backgroundStart.position = CGPoint.zero
        backgroundStart.zPosition = -10
        backgroundStart.size.height = frame.height
        addChild(backgroundStart)
        
        backgroundMiddle.anchorPoint = CGPoint.zero
        backgroundMiddle.position.x = backgroundStart.size.width
        backgroundMiddle.position.y = 0
        backgroundMiddle.zPosition = -10
        backgroundMiddle.size.height = frame.height
        addChild(backgroundMiddle)
        
        colorArray.shuffle()
        
        for i in 1...horseCount {
            buildHorse(number: i)
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
            
            // 말의 움직임 속도 (x축 이동)
            for horse in horseArray {
                horse?.position.x += CGFloat.random(in: -3...4)
            }
        }
    }
    
    
    // horse Atlas를 생성
    func buildHorse(number: Int) {
        // 말이 여러 마리일 경우 prameter로 말 색상 주기 (color)
        // position 변경 -> horse.position = CGPoint(x:y:) 임의로 설정해 둔 상태
        
        let horseAnimatedAtlas = SKTextureAtlas(named: "horse\(number)Images")
        var runFrames: [SKTexture] = []
        
        let horseSpeed: Double = 40
        let numImages = horseAnimatedAtlas.textureNames.count
        
        for i in 1...numImages {
            let horseTextureName = "horse\(number)-\(i)"
            runFrames.append(horseAnimatedAtlas.textureNamed(horseTextureName))
        }
        horseRunningFrames = runFrames
        
        let firstFrameTexture = horseRunningFrames[Int.random(in: 3...5)]
        horseArray.append(SKSpriteNode(texture: firstFrameTexture))
        
        if let horseNode = horseArray[number-1] {
            horseNode.position = CGPoint(x: frame.minX + 150, y: UIScreen.main.bounds.height / CGFloat((horseCount) + 3) * CGFloat(number))
            horseNode.zPosition = -CGFloat(number)  // 위에 있는 말이 뒤로 가도록 zPosition 지정 필요
            horseNode.size = CGSize(width: 188, height: 106)
            addChild(horseNode)
            
            // 3초 이후 배경 및 horse 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.start = true
            }
            
            animateHorse(number: number, speed: horseSpeed)
        }
    }
    
    
    // horse 다리 애니메이션 동작, speed는 말의 다리 움직임 속도(
    func animateHorse(number: Int, speed: Double) {
        let timePerFrame = 1 / speed
        
        // 3초간 대기하는 Action
        let waiting = SKAction.wait(forDuration: 3)
        
        
        // 달리는 Action
        let runningAction = SKAction.repeatForever(SKAction.animate(with: horseRunningFrames,timePerFrame: timePerFrame)
        )
        
        // 앞의 두 Action을 순서대로 수행
        if let horseNode = horseArray[number-1] {
            horseNode.run(SKAction.sequence([waiting, runningAction]),
                          withKey: "horse\(number)Running"
            )
        }
    }
    
}
