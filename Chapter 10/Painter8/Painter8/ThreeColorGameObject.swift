import SpriteKit

class ThreeColorGameObject {
    var node = SKNode()
    var red = SKSpriteNode()
    var green = SKSpriteNode()
    var blue = SKSpriteNode()
    var velocity = CGPoint.zero
    
    init(_ spriteRed: String, _ spriteGreen: String, _ spriteBlue: String) {
        red = SKSpriteNode(imageNamed: spriteRed)
        green = SKSpriteNode(imageNamed: spriteGreen)
        blue = SKSpriteNode(imageNamed: spriteBlue)
        node.addChild(red)
        node.addChild(green)
        node.addChild(blue)
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
            return node.calculateAccumulatedFrame()
        }
    }
    
    func handleInput(_ inputHelper: InputHelper) {
    }
    
    func updateDelta(_ delta: TimeInterval) {
        node.position.x += velocity.x * CGFloat(delta)
        node.position.y += velocity.y * CGFloat(delta)
    }
    
    func reset() {
    }
}
