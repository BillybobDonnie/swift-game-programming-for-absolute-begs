import SpriteKit

class LevelState : SKNode {
    
    var quitButton = Button(imageNamed: "spr_button_quit")
    var levelNr = 0
    var waterDrops = [WaterDrop]()
    
    var tileField = TileField()
    var world = SKNode()
    var levelFinishedOverlay = SKSpriteNode(imageNamed: "spr_welldone")
    var gameoverOverlay = SKSpriteNode(imageNamed: "spr_gameover")
    var helpFrame = SKSpriteNode(imageNamed:"spr_frame_hint")
    
    // initializers
    init(fileReader: FileReader, levelNr : Int) {
        self.levelNr = levelNr
        super.init()
        self.name = "level\(levelNr)"
        self.addChild(world)
        
        quitButton.zPosition = Layer.Overlay
        quitButton.position = GameScreen.instance.topRight - quitButton.center - CGPoint(x: 10, y: 10)
        self.addChild(quitButton)
        
        let _ = fileReader.nextLine() // for now, we do not use help
        let sizeArr = fileReader.nextLine().components(separatedBy: " ")
        let width = Int(sizeArr[0])!, height = Int(sizeArr[1])!
        let _ = Int(fileReader.nextLine())! // for now, we do not use the time for each level
        
        tileField = TileField(rows: height, columns: width, cellWidth: 72, cellHeight: 55)
        tileField.name = "tileField"
        world.addChild(tileField)
        
        // sky
        let background = SKSpriteNode(imageNamed: "spr_sky")
        background.xScale = CGFloat(tileField.layout.width) / background.size.width
        background.yScale = CGFloat(tileField.layout.height) / background.size.height
        background.zPosition = Layer.Background
        world.addChild(background)
        
        var lines: [String] = []
        for _ in 0..<height {
            var newLine = fileReader.nextLine()
            while newLine.characters.count < width {
                newLine += " "
            }
            lines.append(newLine)
        }
        
        
        for i in 0..<height {
            let currLine = lines[height-1-i]
            var j = 0
            for c in currLine.characters {
                tileField.layout.add(loadTile(c, x: j, y: i))
                j += 1
            }
        }
        
        self.reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadTile(_ c: Character, x: Int, y: Int) -> SKNode {
        switch c {
            case "-":
                return loadBasicTile("spr_platform", tileType: TileType.platform)
            case "+":
                return loadBasicTile("spr_platform_hot", tileType: TileType.platform, hot: true)
            case "@":
                return loadBasicTile("spr_platform_ice", tileType: TileType.platform, ice: true)
            case "#":
                return loadBasicTile("spr_wall", tileType: TileType.wall)
            case "^":
                return loadBasicTile("spr_wall_hot", tileType: TileType.wall, hot: true)
            case "*":
                return loadBasicTile("spr_wall_ice", tileType: TileType.wall, ice: true)
            case "W":
                return loadWaterTile(x, y: y)
            default:
                return Tile()
        }
    }
    
    func loadBasicTile(_ imageNamed : String, tileType: TileType, hot: Bool = false, ice: Bool = false) -> SKNode {
        let t = Tile(imageNamed: imageNamed, type: tileType)
        t.hot = hot
        t.ice = ice
        t.zPosition = Layer.Scene
        return t
    }
    
    func loadWaterTile(_ x: Int, y: Int) -> SKNode {
        let w = WaterDrop()
        w.position = tileField.layout.toPosition(x, row: y)
        w.position.y += 10
        w.zPosition = Layer.Scene1
        world.addChild(w)
        self.waterDrops.append(w)
        return Tile()
    }

    override func handleInput(_ inputHelper: InputHelper) {
        super.handleInput(inputHelper)
        if quitButton.tapped {
            self.reset()
            GameStateManager.instance.switchTo("level")
        }
    }
    
    override func reset() {
        super.reset()
        helpFrame.run(SKAction.sequence([SKAction.unhide(),SKAction.wait(forDuration: 5), SKAction.hide()]))
    }
}
