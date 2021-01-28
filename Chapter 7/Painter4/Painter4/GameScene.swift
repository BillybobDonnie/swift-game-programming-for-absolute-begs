import SpriteKit

class Cannon {
    var node = SKNode()
    var barrel = SKSpriteNode(imageNamed:"spr_cannon_barrel")
    var red = SKSpriteNode(imageNamed: "spr_cannon_red")
    var green = SKSpriteNode(imageNamed: "spr_cannon_green")
    var blue = SKSpriteNode(imageNamed: "spr_cannon_blue")
}

class Ball {
    var node = SKNode()
    var red = SKSpriteNode(imageNamed: "spr_ball_red")
    var green = SKSpriteNode(imageNamed: "spr_ball_green")
    var blue = SKSpriteNode(imageNamed: "spr_ball_blue")
    var velocity = CGPoint.zero
    var readyToShoot = false
}

class GameScene: SKScene {
    
    var gameSize = CGSize()
    var gameWorld = SKNode()
    
    var background = SKSpriteNode(imageNamed: "spr_background")
    
    var cannon = Cannon()
    var ball = Ball()
    
    var touchLocation = CGPoint(x: 0, y: 0)
    var nrTouches = 0
    var hasTapped: Bool = false
    
    var delta: TimeInterval = 1/60
    
    override init(size: CGSize) {
        super.init(size: size)
        gameSize = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        background.zPosition = 0
        gameWorld.addChild(background)
        
        initCannon()
        gameWorld.addChild(cannon.node)
        
        initBall()
        gameWorld.addChild(ball.node)
        
        addChild(gameWorld)
        
        view.frameInterval = 2
        delta = TimeInterval(view.frameInterval) / 60
    }
    
    override func update(_ currentTime: TimeInterval) {
        handleInputCannon()
        handleInputBall()
        updateBall()
        hasTapped = false
    }
    
    func initCannon() {
        cannon.red.zPosition = 1
        cannon.green.zPosition = 1
        cannon.blue.zPosition = 1
        cannon.barrel.anchorPoint = CGPoint(x:0.233, y:0.5)
        cannon.node.position = CGPoint(x:-430, y:-280)
        cannon.node.zPosition = 1
        cannon.green.isHidden = true
        cannon.blue.isHidden = true
        cannon.node.addChild(cannon.red)
        cannon.node.addChild(cannon.green)
        cannon.node.addChild(cannon.blue)
        cannon.node.addChild(cannon.barrel)
    }
    
    func handleInputCannon() {
        if nrTouches < 0 {
            return
        }
        let localTouch: CGPoint = gameWorld.convert(touchLocation, to: cannon.red)
        if !cannon.red.frame.contains(localTouch) {
            let opposite = touchLocation.y - cannon.node.position.y
            let adjacent = touchLocation.x - cannon.node.position.x
            cannon.barrel.zRotation = atan2(opposite, adjacent)
        } else if hasTapped {
            let tmp = cannon.blue.isHidden
            cannon.blue.isHidden = cannon.green.isHidden
            cannon.green.isHidden = cannon.red.isHidden
            cannon.red.isHidden = tmp
        }
    }
    
    func initBall() {
        ball.node.zPosition = 1
        ball.node.addChild(ball.red)
        ball.node.addChild(ball.green)
        ball.node.addChild(ball.blue)
        ball.node.isHidden = true
    }
    
    func handleInputBall() {
        let localTouch: CGPoint = gameWorld.convert(touchLocation, to: cannon.red)
        if nrTouches > 0 && !cannon.red.frame.contains(localTouch) && ball.node.isHidden {
            ball.readyToShoot = true
        }
        if (nrTouches <= 0 && ball.readyToShoot && ball.node.isHidden) {
            ball.node.isHidden = false
            ball.readyToShoot = false
            let velocityMultiplier = CGFloat(1.4)
            ball.velocity.x = (touchLocation.x - cannon.node.position.x) * velocityMultiplier
            ball.velocity.y = (touchLocation.y - cannon.node.position.y) * velocityMultiplier
        }
    }
    
    func updateBall() {
        if !ball.node.isHidden {
            ball.velocity.x *= 0.99
            ball.velocity.y -= 15
            ball.node.position.x += ball.velocity.x * CGFloat(delta)
            ball.node.position.y += ball.velocity.y * CGFloat(delta)
        }
        else {
            // calculate the ball position
            let opposite = sin(cannon.barrel.zRotation) * cannon.barrel.size.width * 0.6
            let adjacent = cos(cannon.barrel.zRotation) * cannon.barrel.size.width * 0.6
            ball.node.position = CGPoint(x: cannon.node.position.x + adjacent, y: cannon.node.position.y + opposite)
            
            // set the ball color
            ball.red.isHidden = cannon.red.isHidden
            ball.green.isHidden = cannon.green.isHidden
            ball.blue.isHidden = cannon.blue.isHidden
        }
        if isOutsideWorld(ball.node.position) {
            ball.node.isHidden = true
            ball.readyToShoot = false
        }
    }
    func isOutsideWorld(_ pos: CGPoint) -> Bool {
        return pos.x < -gameSize.width/2 || pos.x > gameSize.width/2 || pos.y < -gameSize.height/2
    }
    
    
    // Touch input handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
        nrTouches += touches.count
        hasTapped = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touchLocation = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nrTouches -= touches.count
    }
}
