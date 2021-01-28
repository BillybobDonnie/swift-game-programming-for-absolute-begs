import SpriteKit

class GameScene: SKScene {
    
    var gameSize = CGSize()
    var gameWorld = SKNode()
    
    var background = SKSpriteNode(imageNamed: "spr_background")
    var cannonBarrel = SKSpriteNode(imageNamed:"spr_cannon_barrel")
    var cannonRed = SKSpriteNode(imageNamed: "spr_cannon_red")
    var cannonGreen = SKSpriteNode(imageNamed: "spr_cannon_green")
    var cannonBlue = SKSpriteNode(imageNamed: "spr_cannon_blue")
    var cannon = SKNode()
    
    var ball = SKNode()
    var ballRed = SKSpriteNode(imageNamed: "spr_ball_red")
    var ballGreen = SKSpriteNode(imageNamed: "spr_ball_green")
    var ballBlue = SKSpriteNode(imageNamed: "spr_ball_blue")
    var ballVelocity = CGPoint.zero
    var readyToShoot = false
    
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
        gameWorld.addChild(cannon)
        
        initBall()
        gameWorld.addChild(ball)
        
        addChild(gameWorld)
        
        delta = TimeInterval(view.frameInterval) / 60
    }
    
    override func update(_ currentTime: TimeInterval) {
        handleInputCannon()
        handleInputBall()
        updateBall()
        hasTapped = false
    }
    
    func initCannon() {
        cannonRed.zPosition = 1
        cannonGreen.zPosition = 1
        cannonBlue.zPosition = 1
        cannonBarrel.anchorPoint = CGPoint(x:0.233, y:0.5)
        cannon.position = CGPoint(x:-430, y:-280)
        cannon.zPosition = 1
        cannonGreen.isHidden = true
        cannonBlue.isHidden = true
        cannon.addChild(cannonRed)
        cannon.addChild(cannonGreen)
        cannon.addChild(cannonBlue)
        cannon.addChild(cannonBarrel)
    }
    
    func handleInputCannon() {
        if nrTouches < 0 {
            return
        }
        let localTouch: CGPoint = gameWorld.convert(touchLocation, to: cannonRed)
        if !cannonRed.frame.contains(localTouch) {
            // rotate the cannon toward the player touch location
            let opposite = touchLocation.y - cannon.position.y
            let adjacent = touchLocation.x - cannon.position.x
            cannonBarrel.zRotation = atan2(opposite, adjacent)
        } else if hasTapped {
            // change the cannon color
            let tmp = cannonBlue.isHidden
            cannonBlue.isHidden = cannonGreen.isHidden
            cannonGreen.isHidden = cannonRed.isHidden
            cannonRed.isHidden = tmp
        }
    }
    
    func initBall() {
        ball.zPosition = 1
        ball.addChild(ballRed)
        ball.addChild(ballGreen)
        ball.addChild(ballBlue)
        ball.isHidden = true
    }
    
    func handleInputBall() {
        let localTouch: CGPoint = gameWorld.convert(touchLocation, to: cannonRed)
        if nrTouches > 0 && !cannonRed.frame.contains(localTouch) && ball.isHidden {
            readyToShoot = true
        }
        if (nrTouches <= 0 && readyToShoot && ball.isHidden) {
            // shoot the ball
            ball.isHidden = false
            readyToShoot = false
            let velocityMultiplier = CGFloat(1.4)
            ballVelocity.x = (touchLocation.x - cannon.position.x) * velocityMultiplier
            ballVelocity.y = (touchLocation.y - cannon.position.y) * velocityMultiplier
        }
    }
    
    func updateBall() {
        if !ball.isHidden {
            ballVelocity.x *= 0.99
            ballVelocity.y -= 15
            ball.position.x += ballVelocity.x * CGFloat(delta)
            ball.position.y += ballVelocity.y * CGFloat(delta)
        }
        else {
            // calculate the ball position
            let opposite = sin(cannonBarrel.zRotation) * cannonBarrel.size.width * 0.6
            let adjacent = cos(cannonBarrel.zRotation) * cannonBarrel.size.width * 0.6
            ball.position = CGPoint(x: cannon.position.x + adjacent, y: cannon.position.y + opposite)
            
            // set the ball color
            ballRed.isHidden = cannonRed.isHidden
            ballGreen.isHidden = cannonGreen.isHidden
            ballBlue.isHidden = cannonBlue.isHidden
        }
        if isOutsideWorld(ball.position) {
            ball.isHidden = true
            readyToShoot = false
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
