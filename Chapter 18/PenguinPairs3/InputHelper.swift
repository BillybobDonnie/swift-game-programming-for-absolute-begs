import SpriteKit

struct Touch {
    var id = Touch.generateId()
    var location = CGPoint()
    var tapped = true
    
    static var idgen: Int = 0
    
    static func generateId() -> Int {
        idgen += 1
        return idgen
    }
}

class InputHelper: NSObject {
    
    var touches: [Touch] = []
    
    var isTouching: Bool {
        get {
            return touches.count > 0
        }
    }
    
    var hasTapped: Bool {
        get {
            for touch in touches {
                if touch.tapped {
                    return true
                }
            }
            return false
        }
    }
    
    func reset() {
        for index in 0..<touches.count  {
            touches[index].tapped = false
        }
    }
    
    func touchBegan(_ loc: CGPoint) -> Int {
        var touch = Touch()
        touch.location = loc
        touches.append(touch)
        return touch.id
    }
    
    func touchMoved(_ id: Int, loc: CGPoint) {
        if let index = findIndex(id) {
            touches[index].location = loc
        }
    }
    
    func touchEnded(_ id: Int) {
        if let index = findIndex(id) {
            touches.remove(at: index)
        }
    }
    
    func findIndex(_ id: Int) -> Int? {
        for index in 0..<touches.count  {
            if touches[index].id == id {
                return index
            }
        }
        return nil
    }
    
    func isTouching(_ id: Int) -> Bool {
        return findIndex(id) != nil
    }
    
    func getTouch(_ id: Int) -> CGPoint {
        if let index = findIndex(id) {
            return touches[index].location
        } else {
            return CGPoint.zero
        }
    }
    
    func hasTapped(_ id: Int) -> Bool {
        if let index = findIndex(id) {
            return touches[index].tapped
        } else {
            return false
        }
    }
    
    func containsTouch(_ rect: CGRect) -> Bool {
        for touch in touches {
            if rect.contains(touch.location) {
                return true
            }
        }
        return false
    }
    
    func getIDInRect(_ rect: CGRect) -> Int? {
        for touch in touches {
            if rect.contains(touch.location) {
                return touch.id
            }
        }
        return nil
    }
    
    func containsTap(_ rect: CGRect) -> Bool {
        for touch in touches {
            if rect.contains(touch.location) && touch.tapped {
                return true
            }
        }
        return false
    }
}
