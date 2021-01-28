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
    
    func handleInput(_ inputHelper: InputHelper) {
        let localTouch: CGPoint = GameScene.world.node.convert(inputHelper.touchLocation, to: GameScene.world.cannon.red)
        if inputHelper.isTouching() && !GameScene.world.cannon.red.frame.contains(localTouch) && node.isHidden {
            readyToShoot = true
        }
        if (!inputHelper.isTouching() && readyToShoot && node.isHidden) {
            node.isHidden = false
            readyToShoot = false
            velocity.x = (inputHelper.touchLocation.x - GameScene.world.cannon.node.position.x) * 1.4
            velocity.y = (inputHelper.touchLocation.y - GameScene.world.cannon.node.position.y) * 1.4
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
            let cannonBarrel = GameScene.world.cannon.barrel
            let cannonNode = GameScene.world.cannon.node
            let opposite = sin(cannonBarrel.zRotation) * cannonBarrel.size.width * 0.6
            let adjacent = cos(cannonBarrel.zRotation) * cannonBarrel.size.width * 0.6
            node.position = CGPoint(x: cannonNode.position.x + adjacent, y: cannonNode.position.y + opposite)
            
            // set the ball color
            red.isHidden = GameScene.world.cannon.red.isHidden
            green.isHidden = GameScene.world.cannon.green.isHidden
            blue.isHidden = GameScene.world.cannon.blue.isHidden
        }
        if GameScene.world.isOutsideWorld(node.position) {
            node.isHidden = true
            readyToShoot = false
        }
    }

}
