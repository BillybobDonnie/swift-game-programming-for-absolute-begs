import SpriteKit

class GameWorld : SKNode {
    
    var size = CGSize()
    var background = SKSpriteNode(imageNamed: "spr_background")
    var cannon = Cannon()
    var ball = Ball()
    var can1 = PaintCan(pOffset: -10, tColor: UIColor.red)
    var can2 = PaintCan(pOffset: 190, tColor: UIColor.green)
    var can3 = PaintCan(pOffset: 390, tColor: UIColor.blue)
    var lives = 5
    var livesNode = SKNode()
    var gameover = SKSpriteNode(imageNamed: "spr_gameover")
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        background.zPosition = 0
        self.addChild(background)
        self.addChild(cannon)
        self.addChild(ball)
        self.addChild(can1)
        self.addChild(can2)
        self.addChild(can3)
        livesNode.position.x = -size.width/2 + 35
        livesNode.position.y = size.height/2 - 120
        self.addChild(livesNode)
        for index in 0...lives-1 {
            let livesSpr = SKSpriteNode(imageNamed: "spr_lives")
            livesSpr.position = CGPoint(x: index * Int(livesSpr.size.width), y: 0)
            livesNode.addChild(livesSpr)
        }
        self.addChild(gameover)
        gameover.zPosition = 2
        gameover.isHidden = true
    }
    
    func handleInput(_ inputHelper: InputHelper) {
        if (lives > 0) {
            cannon.handleInput(inputHelper)
            ball.handleInput(inputHelper)
        } else if (inputHelper.hasTapped) {
            reset()
        }
    }
    
    func updateDelta(_ delta: TimeInterval) {
        gameover.isHidden = lives > 0
        if (lives <= 0) {
            return
        }
        ball.updateDelta(delta)
        can1.updateDelta(delta)
        can2.updateDelta(delta)
        can3.updateDelta(delta)
        for index in 0..<livesNode.children.count {
            let livesSpr = livesNode.children[index] as SKNode
            livesSpr.isHidden = index >= lives
        }
    }
    
    func reset() {
        lives = 5
        cannon.reset()
        ball.reset()
        can1.reset()
        can2.reset()
        can3.reset()
    }
    
    func isOutsideWorld(_ pos: CGPoint) -> Bool {
        return pos.x < -size.width/2 || pos.x > size.width/2 || pos.y < -size.height/2
    }
}
