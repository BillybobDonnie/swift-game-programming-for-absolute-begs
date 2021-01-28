import SpriteKit

class GameScene: SKScene {
    
    var delta: TimeInterval = 1/60
    
    var inputHelper = InputHelper()
    var touchmap: [UITouch:Int] = [UITouch:Int]()
    
    static var world = GameWorld()
    
    override init(size: CGSize) {
        super.init(size: size)
        GameScene.world.size = size
        GameScene.world.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(GameScene.world)
        physicsWorld.contactDelegate = GameScene.world
        view.frameInterval = 2
        delta = TimeInterval(view.frameInterval) / 60
    }
    
    override func update(_ currentTime: TimeInterval) {
        GameScene.world.handleInput(inputHelper)
        GameScene.world.updateDelta(delta)
        inputHelper.reset()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchmap[touch] = inputHelper.touchBegan(location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchid = touchmap[touch]!
            inputHelper.touchMoved(touchid, loc: touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchid = touchmap[touch]!
            touchmap[touch] = nil
            inputHelper.touchEnded(touchid)
        }
    }
  
}
