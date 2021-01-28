import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var balloonSprite = SKSpriteNode(imageNamed: "spr_balloon")
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.lightGray
        balloonSprite.position = CGPoint(x: 200, y: 200)
        addChild(balloonSprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let time = CGFloat(currentTime.truncatingRemainder(dividingBy: 1))
        balloonSprite.position = CGPoint(x: time * size.width, y: 200)
    }

}
