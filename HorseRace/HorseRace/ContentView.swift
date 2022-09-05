import SwiftUI

struct ContentView: View {
    @State var mode: Mode = .GameStart
    @State var horseCount: Int = 2
    
    var body: some View {
        switch mode {
        case .GameStart:
            GameStartView(mode: $mode, horseCount: $horseCount)
        case .FirstGame:
            GameProcessingView(mode: $mode, horseCount: $horseCount)
        case .LastGame:
            FinalGameProcessingView(mode: $mode, horseCount: $horseCount)
        case .Rank:
            GameStartView(mode: $mode, horseCount: $horseCount)
        }
    }
}

enum Mode {
    case GameStart
    case FirstGame
    case LastGame
    case Rank
}
