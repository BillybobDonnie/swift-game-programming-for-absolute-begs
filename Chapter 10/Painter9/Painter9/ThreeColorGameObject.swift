import SpriteKit

class ThreeColorGameObject : SKNode {
    var red = SKSpriteNode()
    var green = SKSpriteNode()
    var blue = SKSpriteNode()
    var velocity = CGPoint.zero
    
    override init() {
        super.init()
        self.addChild(red)
        self.addChild(green)
        self.addChild(blue)
    }
    
    init(_ spriteRed: String, _ spriteGreen: String, _ spriteBlue: String) {
        super.init()
        red = SKSpriteNode(imageNamed: spriteRed)
        green = SKSpriteNode(imageNamed: spriteGreen)
        blue = SKSpriteNode(imageNamed: spriteBlue)
        self.addChild(red)
        self.addChild(green)
        self.addChild(blue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var color: UIColor {
        get {
            if (!red.isHidden) {
                return UIColor.red
            } else if (!green.isHidden) {
                return UIColor.green
            } else {
                return UIColor.blue
            }
        }
        set(col) {
            if col != UIColor.red && col != UIColor.green
                && col != UIColor.blue {
                    return
            }
            red.isHidden = col != UIColor.red
            green.isHidden = col != UIColor.green
            blue.isHidden = col != UIColor.blue
        }
    }
    
    var box: CGRect {
        get {
            return self.calculateAccumulatedFrame()
        }
    }
    
    func handleInput(_ inputHelper: InputHelper) {
    }
    
    func updateDelta(_ delta: TimeInterval) {
        self.position.x += velocity.x * CGFloat(delta)
        self.position.y += velocity.y * CGFloat(delta)
    }
    
    func reset() {
    }
}
