import SpriteKit

class GameScene: SKScene {
    
    var touchingLabel = SKLabelNode(text:"not touching")
    var background = SKSpriteNode(imageNamed: "spr_background")
    var cannonBarrel = SKSpriteNode(imageNamed:"spr_cannon_barrel")
    var touchLocation = CGPoint(x: 0, y: 0)
    var nrTouches = 0
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = 0
        cannonBarrel.zPosition = 1
        touchingLabel.zPosition = 1
        touchingLabel.fontColor = UIColor.black
        cannonBarrel.position = CGPoint(x:-430, y:-280)
        cannonBarrel.anchorPoint = CGPoint(x:0.233, y:0.5)
        addChild(background)
        addChild(cannonBarrel)
        addChild(touchingLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if nrTouches > 0 {
            touchingLabel.text = "touching"
            let opposite = touchLocation.y - cannonBarrel.position.y
            let adjacent = touchLocation.x - cannonBarrel.position.x
            cannonBarrel.zRotation = atan2(opposite, adjacent)
        } else {
            touchingLabel.text = "not touching"
        }
    }
    
    // Touch input handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
        nrTouches = nrTouches + touches.count
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nrTouches -= touches.count
    }
}
