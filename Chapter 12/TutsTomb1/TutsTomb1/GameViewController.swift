import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        skView.ignoresSiblingOrder = true
        
        var viewSize = skView.bounds.size
        if UIDevice.current.userInterfaceIdiom == .phone {
            viewSize.height *= 2
            viewSize.width *= 2
        }
        
        let scene = GameScene(size: viewSize)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }
}
