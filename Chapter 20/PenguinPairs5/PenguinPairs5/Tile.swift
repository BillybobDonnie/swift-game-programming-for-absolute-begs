import SpriteKit

enum TileType {
    case wall
    case background
    case normal
}

class Tile : SKSpriteNode {
    
    fileprivate var tp: TileType = .background
    
    convenience init() {
        self.init(imageNamed: "spr_wall", type: .background)
        self.isHidden = true
    }
    
    init(imageNamed: String, type: TileType) {
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var type : TileType {
        get {
            return tp
        }
        set {
            tp = newValue
            self.isHidden = tp == .background
        }
    }
}
