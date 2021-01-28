import SpriteKit

class AnimatedNode : SKNode {
    
    var animations : [Animation] = []
    
    func loadAnimation(_ atlasNamed: String, looping: Bool = false, frameTime: TimeInterval = 0.05, name: String, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0)) {
        let anim = Animation(atlasNamed: atlasNamed, looping: looping, frameTime: frameTime)
        anim.name = name
        anim.anchorPoint = anchorPoint
        animations.append(anim)
    }
    
    func playAnimation(_ name: String) {
        if childNode(withName: name) != nil {
            return
        }
        for anim in animations {
            if anim.name == name {
                self.removeAllChildren()
                self.addChild(anim)
                anim.run(anim.action)
                return
            }
        }
    }
}
