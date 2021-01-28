import SpriteKit

class Score: GameObjectNode {
    
    // properties
    var sprite = SKSpriteNode(imageNamed: "spr_scorebar")
    var label = SKLabelNode(fontNamed: "CheapPotatoes")
    fileprivate var scoreValue : Int = 0
    
    var score : Int {
        get {
            return scoreValue
        }
        set {
            scoreValue = newValue
            label.text = String(self.scoreValue)
        }
    }
    
    // initializers
    override init() {
        super.init()
        sprite.zPosition = Layer.Overlay
        self.addChild(sprite)
        
        label.position = CGPoint(x: 100, y: 0)
        label.zPosition = Layer.Overlay1
        label.fontColor = UIColor.black
        label.fontSize = 20
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .right
        label.text = "0"
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func reset() {
        self.score = 0
    }
}
