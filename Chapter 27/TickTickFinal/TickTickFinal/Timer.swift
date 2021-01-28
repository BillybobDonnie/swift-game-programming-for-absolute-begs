import SpriteKit

class Timer : SKNode {
    
    var timeLeft: TimeInterval = 0
    var totalTime: TimeInterval = 60
    var textLabel = SKLabelNode(fontNamed: "SmackAttackBB")
    var multiplier = 1.0
    var running = true
    
    init(totalTime: TimeInterval) {
        self.totalTime = totalTime
        self.timeLeft = totalTime
        super.init()
        
        let timerBackground = SKSpriteNode(imageNamed: "spr_timer")
        timerBackground.zPosition = Layer.Overlay
        self.addChild(timerBackground)
        
        textLabel.fontColor = UIColor.yellow
        textLabel.fontSize = 24
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        textLabel.zPosition = Layer.Overlay1
        self.addChild(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func updateDelta(_ delta: TimeInterval) {
        super.updateDelta(delta)
        if self.timeLeft < 0 || !self.running {
            return
        }
        self.timeLeft -= delta * multiplier
        
        let roundedTimeLeft = Int(ceil(timeLeft))
        let minutes = roundedTimeLeft / 60
        let seconds = roundedTimeLeft % 60

        textLabel.text = "\(minutes):\(seconds)"
        if seconds < 10 {
            textLabel.text = "\(minutes):0\(seconds)"
        }
        textLabel.fontColor = UIColor.yellow
        if timeLeft <= 10 && seconds % 2 == 0 {
            textLabel.fontColor = UIColor.red
        }
    }
    
    override func reset() {
        super.reset()
        self.timeLeft = totalTime
        self.running = true
    }
}
