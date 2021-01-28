import SpriteKit

func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

class PaintCan : ThreeColorGameObject {
    var positionOffset = CGFloat(0)
    var targetColor = UIColor.red
    var minVelocity = CGFloat(40)
    var collectPointsSound = Sound("snd_collect_points")
    
    init(pOffset: CGFloat, tColor: UIColor) {
        positionOffset = pOffset
        targetColor = tColor
        super.init("spr_can_red", "spr_can_green", "spr_can_blue")
        self.zPosition = 1
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateDelta(_ delta: TimeInterval) {
        if self.isHidden {
            if randomCGFloat() > 0.01 {
                return
            }
            self.isHidden = false
            self.position = CGPoint(x: positionOffset, y: GameScene.world.size.height/2 + red.size.height/2 + 5)
            velocity = CGPoint(x: 0.0, y: randomCGFloat() * -40 - minVelocity)
            let randomval = arc4random_uniform(3)
            red.isHidden = randomval != 0
            green.isHidden = randomval != 1
            blue.isHidden = randomval != 2
        }
        
        super.updateDelta(delta)
        
        let ball = GameScene.world.ball
        if self.box.intersects(ball.box) {
            color = ball.color
            ball.reset()
        }
        
        let top = CGPoint(x: self.position.x, y: self.position.y + red.size.height/2)
        if GameScene.world.isOutsideWorld(top) {
            if color != targetColor {
                GameScene.world.lives -= 1
            } else {
                GameScene.world.score += 10
                collectPointsSound.play()
            }
            self.isHidden = true
        }
        minVelocity += 0.02
        self.zRotation = sin(position.y / 50) * 0.04
    }
    
    override func reset() {
        self.isHidden = true
        minVelocity = CGFloat(40)
    }
}
