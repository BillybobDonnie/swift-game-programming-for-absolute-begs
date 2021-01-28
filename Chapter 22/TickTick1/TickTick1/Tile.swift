import SpriteKit

enum TileType {
    case wall
    case background
    case platform
}

class Tile : SKSpriteNode {
    
    fileprivate var tileType: TileType = .background
    var hot = false, ice = false
    
    convenience init() {
        self.init(imageNamed: "spr_wall", type: .background)
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
            return tileType
        }
        set {
            tileType = newValue
            self.isHidden = tileType == .background
        }
    }
}
