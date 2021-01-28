import SpriteKit

class Animal : SKSpriteNode {
    
    var boxed = false
    var initialPosition = CGPoint()
    var initialEmptyBox = false
    var type = "x"
    var velocity = CGPoint.zero
    
    init(type: String) {
        boxed = type.uppercased() == type
        var spriteName = "spr_animal_\(type)"
        if boxed && type != "@" {
            spriteName = "spr_animal_boxed_\(type.lowercased())"
        }
        let texture = SKTexture(imageNamed: spriteName)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        self.type = type
        initialEmptyBox = type.lowercased() == "@"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentBlock: (Int, Int) {
        get {
            if let tileField = childNode(withName: "//tileField") as? TileField {
                var edgepos = position
                if velocity.x > 0 {
                    edgepos.x += CGFloat(tileField.layout.cellWidth) / 2
                } else if velocity.x < 0 {
                    edgepos.x -= CGFloat(tileField.layout.cellWidth) / 2
                } else if velocity.y > 0 {
                    edgepos.y += CGFloat(tileField.layout.cellHeight) / 2
                } else if velocity.y < 0 {
                    edgepos.y -= CGFloat(tileField.layout.cellHeight) / 2
                }
                return tileField.layout.toGridLocation(edgepos)
            }
            return (-1, -1)
        }
    }
    
    override func handleInput(_ inputHelper: InputHelper) {
        if isHidden || boxed || isShark || velocity != CGPoint.zero {
            return
        }
        if !inputHelper.containsTap(box) {
            return
        }
        if let animalSelector = childNode(withName: "//animalSelector") as? AnimalSelector {
            if !inputHelper.containsTap(animalSelector.box) || animalSelector.isHidden {
                animalSelector.position = self.position
                animalSelector.isHidden = false
                animalSelector.selectedAnimal = self
            }
        }
    }
    
    override func updateDelta(_ delta: TimeInterval) {
        super.updateDelta(delta)
        position += velocity * CGFloat(delta)
        if isHidden || velocity == CGPoint.zero {
            return
        }
        let tileField = childNode(withName: "//tileField") as! TileField
        let (targetcol, targetrow) = currentBlock
        
        if tileField.getTileType(targetcol, row: targetrow) == .background {
            self.isHidden = true
            self.velocity = CGPoint.zero
        } else if tileField.getTileType(targetcol, row: targetrow) == .wall {
            self.stopMoving()
        } else {
            let lvl = GameStateManager.instance.currentGameState as? LevelState
            if let a = lvl?.findAnimalAtPosition(targetcol, row: targetrow) {
                if a.isHidden {
                    return
                }
                if a.isSeal {
                    stopMoving()
                } else if a.isEmptyBox {
                    self.isHidden = true
                    a.changeTypeTo(self.type.uppercased())
                } else if type.lowercased() == a.type.lowercased() || self.isMulticolor || a.isMulticolor {
                    a.isHidden = true
                    self.isHidden = true
                    let pairList = childNode(withName: "//pairList") as! PairList
                    pairList.addPair(type)
                } else if a.isShark {
                    a.isHidden = true
                    self.isHidden = true
                    stopMoving()
                } else {
                    self.stopMoving()
                }
            }
        }
    }
    
    override func reset() {
        position = initialPosition
        velocity = CGPoint.zero
        isHidden = false
        if initialEmptyBox {
            changeTypeTo("@")
        }
    }
    
    func changeTypeTo(_ type: String) {
        boxed = type.uppercased() == type
        var spriteName = "spr_animal_\(type)"
        if boxed && type != "@" {
            spriteName = "spr_animal_boxed_\(type.lowercased())"
        }
        texture = SKTexture(imageNamed: spriteName)
        self.type = type
    }
    
    func stopMoving() {
        let tileField = childNode(withName: "//tileField") as! TileField
        velocity = CGPoint.normalize(velocity)
        let (currcol, currrow) = currentBlock
        position = tileField.layout.toPosition(currcol  - Int(velocity.x), row: currrow - Int(velocity.y))
        velocity = CGPoint.zero
    }
    
    var isSeal: Bool {
        get {
            return type == "s"
        }
    }
    
    var isMulticolor: Bool {
        get {
            return type == "m"
        }
    }
    
    var isEmptyBox: Bool {
        get {
            return type == "@" && boxed
        }
    }
    
    var isShark: Bool {
        get {
            return type == "x"
        }
    }
}
