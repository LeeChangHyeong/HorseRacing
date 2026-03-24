import SwiftUI

enum GameConfig {
    static let maxHorseCount = 10
    static let minHorseCount = 2
}

struct ContentView: View {
    @State var mode: Mode = .GameStart
    @State var horseCount: Int = GameConfig.minHorseCount
    @State var resultInfo: [Double] = []
    @State var horseNames = Array(repeating: "", count: GameConfig.maxHorseCount)
    
    let BGM = SoundSetting(forResouce: "MA_JingleRepublic_TrendyJumpingYouth_Main", withExtension: "wav")
    
    var body: some View {
        ZStack {
            switch mode {
            case .GameStart:
                GameStartView(mode: $mode, horseCount: $horseCount, horseNames: $horseNames)
            case .FirstGame:
                GameProcessingView(mode: $mode, horseCount: $horseCount)
            case .LastGame:
                FinalGameProcessingView(mode: $mode, horseCount: $horseCount, resultInfo: $resultInfo)
            case .Rank:
                ResultView(mode: $mode, resultInfo: $resultInfo, horseNames: $horseNames)
            }
        }
        .onAppear{
            BGM.playSound()
        }
        .onChange(of: mode) { newValue in
            if newValue == .GameStart || newValue == .FirstGame {
                setNewSpeed()
            }
        }

    }
    
    private func setNewSpeed() {
        resultInfo = []
        for _ in 1...horseCount {
            resultInfo.append(Double.random(in: 60.0...120.0))
        }
    }
}

enum Mode {
    case GameStart
    case FirstGame
    case LastGame
    case Rank
}
