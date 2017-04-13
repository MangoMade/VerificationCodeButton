

import UIKit

// MARK: - consts about main screen
struct Screen {
    
    static var bounds: CGRect {
        return UIScreen.main.bounds
    }
    
    static var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
    
    static var size: CGSize {
        return Screen.bounds.size
    }
    
    static var width: CGFloat {
        return Screen.size.width
    }
    
    static var height: CGFloat {
        return Screen.size.height
    }
    
    static var scale: CGFloat {
        return UIScreen.main.scale
    }
    
    static var onePX: CGFloat {
        return 1 / Screen.scale
    }
    
    static let navBarHeight: CGFloat = 64
    
    static let tabBarHeight: CGFloat = 49
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
}
