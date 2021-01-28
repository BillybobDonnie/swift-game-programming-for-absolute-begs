import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DefaultsManager {
    
    static var instance = DefaultsManager()
    
    var defaults = UserDefaults.standard
    
    init() {
        if defaults.array(forKey: "levelStatus") != nil {
            /* the default settings were already created for this player,
               so we're done. */
            return
        }
        let filePath = Bundle.main.path(forResource: "defaults", ofType:"plist")
        let defaultPreferences: NSDictionary = NSDictionary(contentsOfFile: filePath!)!
        for (key, value) in defaultPreferences {
            defaults.set(value, forKey: key as! String)
        }
    }
    
    func reset() {
        let filePath = Bundle.main.path(forResource: "defaults", ofType:"plist")
        let defaultPreferences: NSDictionary = NSDictionary(contentsOfFile: filePath!)!
        for (key, _) in defaultPreferences {
            defaults.removeObject(forKey: key as! String)
        }
    }
    
    func getLevelStatus(_ levelNr: Int) -> String {
        let levels = defaults.array(forKey: "levelStatus")
        if levelNr < 1 || levelNr > levels?.count {
            return "locked"
        } else {
            return levels?[levelNr - 1] as! String
        }
    }
    
    func setLevelStatus(_ levelNr: Int, status: String) {
        var levels = defaults.array(forKey: "levelStatus")
        if levelNr < 1 || levelNr > levels?.count {
            return
        } else {
            levels![levelNr - 1] = status
            defaults.set(levels, forKey: "levelStatus")
        }
    }
}
