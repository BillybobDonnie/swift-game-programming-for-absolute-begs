import SpriteKit

class PlayerFollowingEnemy : PatrollingEnemy {
    
    override func updateDelta(_ delta: TimeInterval) {
        super.updateDelta(delta)
        
        let player = childNode(withName: "//player") as! Player
        let direction = player.position.x - self.position.x
        if direction * velocity.x < 0 && player.velocity != CGPoint.zero {
            self.turnAround()
        }
    }
}
