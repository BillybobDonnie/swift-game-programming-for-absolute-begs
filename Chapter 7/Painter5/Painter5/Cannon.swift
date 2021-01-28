import SpriteKit

class Cannon {
    var node = SKNode()
    var barrel = SKSpriteNode(imageNamed:"spr_cannon_barrel")
    var red = SKSpriteNode(imageNamed: "spr_cannon_red")
    var green = SKSpriteNode(imageNamed: "spr_cannon_green")
    var blue = SKSpriteNode(imageNamed: "spr_cannon_blue")
    
    init() {
        red.zPosition = 1
        green.zPosition = 1
        blue.zPosition = 1
        barrel.anchorPoint = CGPoint(x:0.233, y:0.5)
        node.position = CGPoint(x:-430, y:-280)
        node.zPosition = 1
        green.isHidden = true
        blue.isHidden = true
        node.addChild(red)
        node.addChild(green)
        node.addChild(blue)
        node.addChild(barrel)
    }
    
    func handleInput(_ inputHelper: InputHelper) {
        if !inputHelper.isTouching() {
            return
        }
        let localTouch: CGPoint = GameScene.world.node.convert(inputHelper.touchLocation, to: red)
        if !red.frame.contains(localTouch) {
            let opposite = inputHelper.touchLocation.y - node.position.y
            let adjacent = inputHelper.touchLocation.x - node.position.x
            barrel.zRotation = atan2(opposite, adjacent)
        } else if inputHelper.hasTapped {
            let tmp = blue.isHidden
            blue.isHidden = green.isHidden
            green.isHidden = red.isHidden
            red.isHidden = tmp
        }
    }

}
