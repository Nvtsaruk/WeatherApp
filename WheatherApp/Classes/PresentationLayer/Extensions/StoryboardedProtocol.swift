import Foundation
import UIKit

protocol Storyboarded {
    static func containingStoryboard() -> Storyboard
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let controller: Self = containingStoryboard().viewController()
        return controller
    }
}
