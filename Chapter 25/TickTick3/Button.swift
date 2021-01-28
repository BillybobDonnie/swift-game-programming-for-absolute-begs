import SpriteKit

class Button: SKSpriteNode {
    
    // properties
    var tapped = false
    var down = false
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleInput(_ inputHelper: InputHelper) {
        super.handleInput(inputHelper)
        tapped = inputHelper.containsTap(self.box) && !self.isHidden
        down = inputHelper.containsTouch(self.box) && !self.isHidden
    }
}
