import SpriteKit

struct Layer {
    static let Background : CGFloat = 0
    static let Scene : CGFloat = 1
    static let Scene1 : CGFloat = 2
    static let Scene2 : CGFloat = 3
    static let Overlay : CGFloat = 10
    static let Overlay1 : CGFloat = 11
    static let Overlay2 : CGFloat = 12
}

class GameScene: SKScene {
    
    var delta: TimeInterval = 1/60
    
    var inputHelper = InputHelper()
    var touchmap: [UITouch:Int] = [UITouch:Int]()
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(GameStateManager.instance)
        view.frameInterval = 2
        delta = TimeInterval(view.frameInterval) / 60
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameScreen.instance.size = size
        
        // create the game states
        GameStateManager.instance.add(TitleMenuState())
        GameStateManager.instance.add(HelpState())
        GameStateManager.instance.add(OptionsMenuState())
        
        // add the levels
        let levels = FileReader(filename: "levels")
        let nrLevels = Int(levels.nextLine())!
        
        GameStateManager.instance.add(LevelMenuState(nrLevels: nrLevels))
        
        for i in 1...nrLevels {
            GameStateManager.instance.add(LevelState(fileReader: levels, levelNr: i))
        }
        
        GameStateManager.instance.switchTo("title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        GameStateManager.instance.handleInput(inputHelper)
        GameStateManager.instance.updateDelta(delta)
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
