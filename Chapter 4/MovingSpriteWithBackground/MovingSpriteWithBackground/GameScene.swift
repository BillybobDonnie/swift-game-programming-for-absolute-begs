import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var backgroundSprite = SKSpriteNode(imageNamed: "spr_background")
    var balloonSprite = SKSpriteNode(imageNamed: "spr_balloon")
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundSprite.zPosition = 0
        balloonSprite.zPosition = 1
        addChild(backgroundSprite)
        addChild(balloonSprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let time = CGFloat(currentTime.truncatingRemainder(dividingBy: 1))
        balloonSprite.position = CGPoint(x: time * size.width - size.width/2, y: 200)
    }
    
}
