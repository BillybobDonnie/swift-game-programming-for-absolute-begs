import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var audioPlayer = AVAudioPlayer()
    
    override func didMove(to view: SKView) {
        let soundURL = Bundle.main.url(forResource: "snd_music", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
        audioPlayer.play()
        audioPlayer.volume = 0.4
    }
}
