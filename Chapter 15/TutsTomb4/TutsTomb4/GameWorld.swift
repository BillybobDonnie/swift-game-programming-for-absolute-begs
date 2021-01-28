import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


func randomDouble() -> Double {
    return Double(arc4random()) / Double(UInt32.max)
}

class GameWorld : GameObjectNode, SKPhysicsContactDelegate {
    
    var size = CGSize()
    var titleScreen = SKSpriteNode(imageNamed:"spr_title")
    var gameover = SKSpriteNode(imageNamed: "spr_gameover")
    var helpframe = SKSpriteNode(imageNamed: "spr_help")
    var helpbutton = Button(imageNamed: "spr_button_help")
    var totalAction = SKAction()
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
        background.zPosition = Layer.Background
        addChild(background)
        
        let chimney = SKSpriteNode(imageNamed:"spr_chimney")
        chimney.zPosition = Layer.Scene2
        chimney.position.y = 510
        addChild(chimney)
        
        self.addChild(treasures)
        
        // create the actions
        let dropTreasureAction = SKAction.run({
            self.treasures.addChild(Treasure(range: 5 + UInt32(self.counter)/10))
            self.counter += 1
        })
        
        totalAction = SKAction.repeatForever(
            SKAction.sequence([dropTreasureAction, SKAction.wait(forDuration: 2)]))
        
        // titlescreen
        titleScreen.zPosition = Layer.Overlay2
        addChild(titleScreen)
        
        self.addChild(gameover)
        gameover.zPosition = Layer.Overlay2
        gameover.isHidden = true
        
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
        
        // help
        var helppos = topRight()
        helppos.x -= helpbutton.sprite.size.width/2 + 10
        helppos.y -= helpbutton.sprite.size.height/2 + 10
        helpbutton.position = helppos
        helpbutton.zPosition = Layer.Overlay
        self.addChild(helpbutton)
        self.addChild(helpframe)
        helpframe.zPosition = Layer.Overlay2
        helpframe.isHidden = true
    }
    
    override func handleInput(_ inputHelper: InputHelper) {
        if !titleScreen.isHidden {
            if inputHelper.hasTapped {
                titleScreen.isHidden = true
                self.run(totalAction)
            }
        } else if !gameover.isHidden {
            if inputHelper.hasTapped {
                gameover.isHidden = true
                self.reset()
                self.run(totalAction)
            }
        } else if !helpframe.isHidden {
            if inputHelper.hasTapped {
                helpframe.isHidden = true
                self.run(totalAction)
            }
        } else {
            super.handleInput(inputHelper)
            if helpbutton.tapped  {
                helpframe.isHidden = false
                self.removeAllActions()
            }
        }
    }
    
    override func updateDelta(_ delta: TimeInterval) {
        if titleScreen.isHidden && helpframe.isHidden && gameover.isHidden {
            super.updateDelta(delta)
        }
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
        if firstBody?.parent == nil && secondBody?.parent == nil {
            return
        }
        
        if firstBody?.position.y > 400 || secondBody?.position.y > 400 {
            gameover.isHidden = false
            self.removeAllActions()
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
