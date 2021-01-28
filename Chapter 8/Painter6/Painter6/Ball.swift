import SpriteKit

class Ball {
    var node = SKNode()
    var red = SKSpriteNode(imageNamed: "spr_ball_red")
    var green = SKSpriteNode(imageNamed: "spr_ball_green")
    var blue = SKSpriteNode(imageNamed: "spr_ball_blue")
    var velocity = CGPoint.zero
    var readyToShoot = false
    
    init() {
        node.zPosition = 1
        node.addChild(red)
        node.addChild(green)
        node.addChild(blue)
        node.isHidden = true
    }
    
    convenience init(position: CGPoint) {
        self.init()
        node.position = position
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
    
    func handleInput(_ inputHelper: InputHelper) {
        let localTouch: CGPoint = GameScene.world.node.convert(inputHelper.touchLocation, to: GameScene.world.cannon.red)
        if inputHelper.isTouching && !GameScene.world.cannon.red.frame.contains(localTouch) && node.isHidden {
            readyToShoot = true
        }
        if (!inputHelper.isTouching && readyToShoot && node.isHidden) {
            node.isHidden = false
            readyToShoot = false
            let velocityMultiplier = CGFloat(1.4)
            velocity.x = (inputHelper.touchLocation.x - GameScene.world.cannon.node.position.x) * velocityMultiplier
            velocity.y = (inputHelper.touchLocation.y - GameScene.world.cannon.node.position.y) * velocityMultiplier
        }
    }
    
    func updateDelta(_ delta: TimeInterval) {
        if !node.isHidden {
            velocity.x *= 0.99
            velocity.y -= 15
            node.position.x += velocity.x * CGFloat(delta)
            node.position.y += velocity.y * CGFloat(delta)
        }
        else {
            // calculate the ball position
            node.position = GameScene.world.cannon.ballPosition
            
            // set the ball color
            red.isHidden = GameScene.world.cannon.red.isHidden
            green.isHidden = GameScene.world.cannon.green.isHidden
            blue.isHidden = GameScene.world.cannon.blue.isHidden
        }
        if GameScene.world.isOutsideWorld(node.position) {
            reset()
        }
    }
    
    func reset() {
        node.isHidden = true
        readyToShoot = false
    }
    
}
