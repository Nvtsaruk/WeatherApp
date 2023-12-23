import UIKit
extension UILabel {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.7
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1.7, height: 1.7)
        self.layer.masksToBounds = false
    }
}
