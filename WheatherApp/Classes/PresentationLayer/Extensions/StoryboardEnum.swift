import UIKit

enum Storyboard: String {
    case WeatherView
    case MainPageView
    case LocationsView
    case SearchView
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>() -> T {
        let identifier = String(describing: T.self)
        guard let viewController = self.instance.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Failed to instantiate view controller with identifier \(identifier)")
        }
        return viewController
    }
}
