import SpriteKit

class GameScene: SKScene {
    
    var touchingLabel = SKLabelNode(text:"not touching")
    var background = SKSpriteNode(imageNamed: "spr_background")
    var cannonBarrel = SKSpriteNode(imageNamed:"spr_cannon_barrel")
    var cannonRed = SKSpriteNode(imageNamed: "spr_cannon_red")
    var cannonGreen = SKSpriteNode(imageNamed: "spr_cannon_green")
    var cannonBlue = SKSpriteNode(imageNamed: "spr_cannon_blue")
    var touchLocation = CGPoint(x: 0, y: 0)
    var nrTouches = 0
    var hasTapped: Bool = false
    
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = 0
        cannonBarrel.zPosition = 1
        touchingLabel.zPosition = 1
        touchingLabel.fontColor = UIColor.black
        cannonBarrel.position = CGPoint(x:-430, y:-280)
        cannonBarrel.anchorPoint = CGPoint(x:0.233, y:0.5)
        cannonRed.position = cannonBarrel.position
        cannonGreen.position = cannonBarrel.position
        cannonBlue.position = cannonBarrel.position
        cannonRed.zPosition = 2
        cannonGreen.zPosition = 2
        cannonBlue.zPosition = 2
        cannonGreen.isHidden = true
        cannonBlue.isHidden = true
        addChild(cannonRed)
        addChild(cannonGreen)
        addChild(cannonBlue)
        addChild(background)
        addChild(cannonBarrel)
        addChild(touchingLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if nrTouches > 0 {
            // we now know that the player is touching the screen somewhere, so we change
            // the label text
            touchingLabel.text = "touching"
            if !cannonRed.frame.contains(touchLocation) {
                // the player is touching the screen outside of the cannon barrel frame, 
                // so simply rotate the cannon
                let opposite = touchLocation.y - cannonBarrel.position.y
                let adjacent = touchLocation.x - cannonBarrel.position.x
                cannonBarrel.zRotation = atan2(opposite, adjacent)
            }
            else if hasTapped {
                // the player is has tapped on the screen inside the cannon barrel frame,
                // so change the color of the cannon
                let tmp = cannonBlue.isHidden
                cannonBlue.isHidden = cannonGreen.isHidden
                cannonGreen.isHidden = cannonRed.isHidden
                cannonRed.isHidden = tmp
            }
        } else {
            // the player is not touching the screen, so we update the label text accordingly
            touchingLabel.text = "not touching"
        }
        hasTapped = false
    }
        
    // Touch input handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
        nrTouches = nrTouches + touches.count
        hasTapped = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nrTouches -= touches.count
    }
}
