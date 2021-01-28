import SpriteKit

class GameScene: SKScene {
    
    var balloonSprite = SKSpriteNode(imageNamed: "spr_balloon")
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.lightGray
        balloonSprite.position = CGPoint(x: 200, y: 200)
        addChild(balloonSprite)
    }
}
