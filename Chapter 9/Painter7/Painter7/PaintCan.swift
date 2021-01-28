import SpriteKit

func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

class PaintCan {
    var node = SKNode()
    var red = SKSpriteNode(imageNamed: "spr_can_red")
    var green = SKSpriteNode(imageNamed: "spr_can_green")
    var blue = SKSpriteNode(imageNamed: "spr_can_blue")
    var velocity = CGPoint.zero
    
    var positionOffset = CGFloat(0)
    var targetColor = UIColor.red
    var minVelocity = CGFloat(40)
    
    init(positionOffset: CGFloat, targetColor: UIColor) {
        self.positionOffset = positionOffset
        self.targetColor = targetColor
        node.zPosition = 1
        node.addChild(red)
        node.addChild(green)
        node.addChild(blue)
        node.isHidden = true
    }
    
    var color: UIColor {
        get {
            if (!red.isHidden) {
                return UIColor.red
            } else if (!green.isHidden) {
                return UIColor.green
            } else {
                return UIColor.blue
            }
        }
        set(col) {
            if col != UIColor.red && col != UIColor.green
                && col != UIColor.blue {
                    return
            }
            red.isHidden = col != UIColor.red
            green.isHidden = col != UIColor.green
            blue.isHidden = col != UIColor.blue
        }
    }
    
    func updateDelta(_ delta: TimeInterval) {
        if node.isHidden {
            if randomCGFloat() > 0.01 {
                return
            }
            node.isHidden = false
            node.position = CGPoint(x: positionOffset, y: GameScene.world.size.height/2 + red.size.height/2 + 5)
            velocity = CGPoint(x: 0.0, y: randomCGFloat() * -40 - minVelocity)
            let randomval = arc4random_uniform(3)
            red.isHidden = randomval != 0
            green.isHidden = randomval != 1
            blue.isHidden = randomval != 2
        }
        
        node.position.x += velocity.x * CGFloat(delta)
        node.position.y += velocity.y * CGFloat(delta)
        
        let paintCanBox = node.calculateAccumulatedFrame()
        let ballBox = GameScene.world.ball.node.calculateAccumulatedFrame()
        if paintCanBox.intersects(ballBox) {
            color = GameScene.world.ball.color
            GameScene.world.ball.reset()
        }
        
        let top = CGPoint(x: node.position.x, y: node.position.y + red.size.height/2)
        if GameScene.world.isOutsideWorld(top) {
            if color != targetColor {
                GameScene.world.lives -= 1;
            }
            node.isHidden = true
        }
        minVelocity += 0.02
    }
    
    func reset() {
        node.isHidden = true
        minVelocity = CGFloat(40)
    }

}
