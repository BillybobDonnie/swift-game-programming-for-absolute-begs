import SpriteKit

class PatrollingEnemy : AnimatedNode {
    
    var waitTime : CGFloat = 0
    var velocity = CGPoint(x: 120, y: 0)
    
    override init() {
        super.init()
        loadAnimation("spr_flame", looping: true, frameTime: 0.1, name: "default")
        playAnimation("default")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateDelta(_ delta: TimeInterval) {
        super.updateDelta(delta)
        position += velocity * CGFloat(delta)
        if waitTime > 0 {
            waitTime -= CGFloat(delta)
            if waitTime <= 0 {
                self.turnAround()
            }
        } else {
            let tileField = childNode(withName: "//tileField") as! TileField
            var (col, row) = tileField.layout.toGridLocation(self.position)
            if xScale < 0 {
                col -= 1
            } else {
                col += 1
            }
            if tileField.getTileType(col, row: row - 1) == .background || tileField.getTileType(col, row: row) == .wall {
                waitTime = 0.5
                velocity = CGPoint.zero
            }
        }
    }
    
    func turnAround() {
        xScale = -xScale
        velocity.x = 120 * xScale
    }
}
