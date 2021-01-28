import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 65
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        addChild(myLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        backgroundColor = UIColor.blue
    }
}
