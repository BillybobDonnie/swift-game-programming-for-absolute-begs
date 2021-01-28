import SpriteKit

class OnOffButton : SKSpriteNode {
    
    var onTexture = SKTexture(imageNamed: "spr_button_on")
    var offTexture = SKTexture(imageNamed: "spr_button_off")
    
    init() {
        super.init(texture: onTexture, color: UIColor.white, size: onTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var on: Bool {
        get {
            return self.texture == onTexture
        }
        set {
            if newValue {
                self.texture = onTexture
            } else {
                self.texture = offTexture
            }
        }
    }
    
    override func handleInput(_ inputHelper: InputHelper) {
        super.handleInput(inputHelper)
        if inputHelper.containsTap(self.box) && !self.isHidden {
            self.on = !self.on
        }
    }
}
