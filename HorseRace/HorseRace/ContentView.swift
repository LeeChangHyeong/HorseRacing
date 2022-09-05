import SwiftUI

struct ContentView: View {
    @State var mode: Mode = .GameStart
    @State var horseCount: Int = 2
    @State var resultInfo: [Int] = []
    
    var body: some View {
        ZStack {
            switch mode {
            case .GameStart:
                GameStartView(mode: $mode, horseCount: $horseCount)
            case .FirstGame:
                GameProcessingView(mode: $mode, horseCount: $horseCount)
            case .LastGame:
                FinalGameProcessingView(mode: $mode, horseCount: $horseCount, resultInfo: $resultInfo)
            case .Rank:
                ResultView(mode: $mode, resultInfo: $resultInfo)
            }
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
            resultInfo.append((60...120).randomElement() ?? 60 )
        }
    }
}

enum Mode {
    case GameStart
    case FirstGame
    case LastGame
    case Rank
}
