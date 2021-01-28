import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Sound {
    
    // properties
    fileprivate var audioPlayer: AVAudioPlayer?
    
    // initializers
    init(_ fileName: String) {
        let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: soundURL!)
    }
    
    // properties
    var looping: Bool {
        get {
            return audioPlayer?.numberOfLoops < 0
        }
        set {
            if newValue {
                audioPlayer?.numberOfLoops = -1
            } else {
                audioPlayer?.numberOfLoops = 0
            }
        }
    }
    
    var volume: Float {
        get {
            if audioPlayer != nil {
                return audioPlayer!.volume
            } else {
                return 0
            }
        }
        set {
            audioPlayer?.volume = newValue
        }
    }
    
    // methods
    func play() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
}
