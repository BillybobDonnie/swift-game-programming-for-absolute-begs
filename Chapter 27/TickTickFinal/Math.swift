import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

func *= (left: inout CGPoint, right: CGFloat) {
    left = left * right
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func * (left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left * right.x, y: left * right.y)
}

func == (left: CGPoint, right: CGPoint) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}
func != (left: CGPoint, right: CGPoint) -> Bool {
    return !(left == right)
}

func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) /  CGFloat(UInt32.max)
}

func clamp(_ number:CGFloat, min:CGFloat, max:CGFloat) -> CGFloat
{
    if number < min {
        return min
    }
    else if number > max {
        return max
    }
    return number
}

extension CGPoint {
    static func normalize(_ p : CGPoint) -> CGPoint {
        let len = p.length
        return CGPoint(x: p.x / len, y: p.y / len)
    }
    
    var length : CGFloat {
        get {
            return sqrt(self.x * self.x + self.y * self.y)
        }
    }
}

extension CGRect {
    func calculateIntersectionDepth(_ rect: CGRect) -> CGPoint {
        let minDistance = CGPoint(x: (self.size.width + rect.size.width)/2, y: (self.size.height + rect.size.height)/2)
        let distance = CGPoint(x: self.midX - rect.midX, y: self.midY - rect.midY)
        var depth = CGPoint.zero
        if distance.x > 0 {
            depth.x = minDistance.x - distance.x
        } else {
            depth.x = -minDistance.x - distance.x
        }
        if distance.y > 0 {
            depth.y = minDistance.y - distance.y
        } else {
            depth.y = -minDistance.y - distance.y
        }
        return depth
    }
}
