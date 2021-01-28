import SpriteKit

extension SKNode {
    var box: CGRect {
        get {
            var boundingBox = self.calculateAccumulatedFrame()
            if parent != nil {
                boundingBox.origin = scene!.convert(boundingBox.origin, from: parent!)
            }
            return boundingBox
        }
    }
    
    var worldPosition: CGPoint {
        get {
            if parent != nil {
                return parent!.convert(position, to: scene!)
            } else {
                return position
            }
        }
    }
    
    func handleInput(_ inputHelper: InputHelper) {
        for obj in children {
            obj.handleInput(inputHelper)
        }
    }
    
    func updateDelta(_ delta: TimeInterval) {
        for obj in children {
            obj.updateDelta(delta)
        }
    }
    
    func reset() {
        for obj in children {
            obj.reset()
        }
    }
}
