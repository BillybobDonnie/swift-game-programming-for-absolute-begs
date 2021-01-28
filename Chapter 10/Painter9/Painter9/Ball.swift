import SpriteKit

class Ball : ThreeColorGameObject {
    var readyToShoot = false
    
    override init() {
        super.init("spr_ball_red", "spr_ball_green", "spr_ball_blue")
        self.zPosition = 1
        self.isHidden = true
    }
    
    convenience init(position: CGPoint) {
        self.init()
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleInput(_ inputHelper: InputHelper) {
        let localTouch: CGPoint = GameScene.world.convert(inputHelper.touchLocation, to: GameScene.world.cannon.red)
        if inputHelper.isTouching && !GameScene.world.cannon.red.frame.contains(localTouch) && self.isHidden {
            readyToShoot = true
        }
        if (!inputHelper.isTouching && readyToShoot && self.isHidden) {
            self.isHidden = false
            readyToShoot = false
            let velocityMultiplier = CGFloat(1.4)
            velocity.x = (inputHelper.touchLocation.x - GameScene.world.cannon.position.x) * velocityMultiplier
            velocity.y = (inputHelper.touchLocation.y - GameScene.world.cannon.position.y) * velocityMultiplier
        }
    }
    
    override func updateDelta(_ delta: TimeInterval) {
        if !self.isHidden {
            velocity.x *= 0.99
            velocity.y -= 15
            super.updateDelta(delta)
        } else {
            // calculate the ball position
            self.position = GameScene.world.cannon.ballPosition
            
            // copy the ball color
            self.color = GameScene.world.cannon.color
        }
        if GameScene.world.isOutsideWorld(self.position) {
            reset()
        }
    }
    
    override func reset() {
        self.isHidden = true
        readyToShoot = false
    }
    
}
