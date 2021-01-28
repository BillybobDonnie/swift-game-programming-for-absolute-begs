import SpriteKit

func randomDouble() -> Double {
    return Double(arc4random()) / Double(UInt32.max)
}

class GameWorld : GameObjectNode, SKPhysicsContactDelegate {
    
    var size = CGSize()
    var treasures = GameObjectNode()
    var counter = 0
    
    // initializers
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let background = SKSpriteNode(imageNamed:"spr_background")
        background.zPosition = 0
        addChild(background)
        
        let chimney = SKSpriteNode(imageNamed:"spr_chimney")
        chimney.zPosition = 10
        chimney.position.y = 510
        addChild(chimney)
        
        self.addChild(treasures)
        
        // create the actions
        let dropTreasureAction = SKAction.run({
            let r: UInt32 = UInt32(self.counter)/10 + 5
            self.treasures.addChild(Treasure(range: r))
            self.counter += 1
        })
        
        let sequence = SKAction.sequence([dropTreasureAction, SKAction.wait(forDuration: 2)])
        let totalAction = SKAction.repeatForever(sequence)
        
        self.run(totalAction)
        
        // add the surrounding walls
        let floor = SKNode()
        floor.position.y = -400
        var square = CGSize(width: GameScene.world.size.width, height: 200)
        floor.physicsBody = SKPhysicsBody(rectangleOf: square)
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        let ceiling = SKNode()
        ceiling.position.y = 800
        square = CGSize(width: GameScene.world.size.width, height: 200)
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: square)
        ceiling.physicsBody?.isDynamic = false
        addChild(ceiling)
        
        
        let leftSideWall = SKNode()
        leftSideWall.position.x = -340
        square = CGSize(width: 100, height: GameScene.world.size.height)
        leftSideWall.physicsBody = SKPhysicsBody(rectangleOf: square)
        leftSideWall.physicsBody?.isDynamic = false
        addChild(leftSideWall)
        
        let rightSideWall = SKNode()
        rightSideWall.position.x = 340
        square = CGSize(width: 100, height: size.height)
        rightSideWall.physicsBody = SKPhysicsBody(rectangleOf: square)
        rightSideWall.physicsBody?.isDynamic = false
        addChild(rightSideWall)
    }
    
    override func reset() {
        super.reset()
        self.treasures.removeAllChildren()
        self.counter = 0
    }
    
    // physics handling
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node as? Treasure
        let secondBody = contact.bodyB.node as? Treasure
        
        if firstBody == nil || secondBody == nil {
            return
        }
        if firstBody?.parent == nil || secondBody?.parent == nil {
            return
        }
        
        if firstBody?.type == TreasureType.Rock && secondBody?.type == TreasureType.Rock {
            return
        }
        
        if firstBody?.type == secondBody?.type || firstBody?.type == TreasureType.Magic
            || secondBody?.type == TreasureType.Magic {
                firstBody?.removeFromParent()
                secondBody?.removeFromParent()
        }
    }
    
    func isOutsideWorld(_ pos: CGPoint) -> Bool {
        return pos.x < -size.width/2 || pos.x > size.width/2 || pos.y < -size.height/2
    }
    
    func topLeft() -> CGPoint {
        return CGPoint(x: -size.width/2, y: size.height/2)
    }
    
    func topRight() -> CGPoint {
        return CGPoint(x: size.width/2, y: size.height/2)
    }
}
