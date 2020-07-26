
import UIKit
//1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}
//2
extension Int {
    func times(_ completionHandler: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0..<self {
            completionHandler()
        }
    }
}
//3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        var elementCount = 0
        
        for item in self {
            if item == item {
                elementCount += 1
            }
        }
        
        if elementCount > 1 {
            guard let index = self.firstIndex(of: item) else { return }
            self.remove(at: index)
        }
    }
}
//
