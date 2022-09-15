//
//  SoundSetting.swift
//  HorseRace
//
//  Created by DongKyu Kim on 2022/09/15.
//
import AVKit

class SoundSetting {
    // static let sound = SoundSetting()
    var player: AVAudioPlayer?
    let forResource: String
    let withExtension: String
    
    init(forResouce: String, withExtension: String) {
        self.forResource = forResouce
        self.withExtension = withExtension
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
            if forResource == "MA_JingleRepublic_TrendyJumpingYouth_Main" {
                player?.numberOfLoops = 100
                player?.volume = 0.3
            }
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
}
