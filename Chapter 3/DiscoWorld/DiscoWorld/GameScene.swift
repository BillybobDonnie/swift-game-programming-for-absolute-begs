import SpriteKit

class GameScene: SKScene {
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    override func didMove(to view: SKView) {
        myLabel.text = "Disco!"
        myLabel.fontSize = 65
        addChild(myLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        let time: Double = currentTime.truncatingRemainder(dividingBy: 1)
        backgroundColor = UIColor(red: CGFloat(time), green: 0, blue: 0, alpha: 1)
    }
}
