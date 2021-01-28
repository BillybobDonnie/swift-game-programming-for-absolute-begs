import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var backgroundSprite = SKSpriteNode(imageNamed: "spr_screensizes")
    var touchPosLabel = SKLabelNode(text:"(,)")
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        touchPosLabel.position.y = -200
        addChild(backgroundSprite)
        addChild(touchPosLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let pos = touch.location(in: self)
        touchPosLabel.text = "(\(pos.x), \(pos.y))"
    }
}
