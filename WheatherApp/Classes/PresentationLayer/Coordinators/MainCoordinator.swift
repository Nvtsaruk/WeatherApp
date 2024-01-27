import UIKit
import Hero
final class MainCoordinator: Coordinator {
    
    let navigationController = UINavigationController()
    let locale = LocaleEnum(rawValue: Locale.current.language.languageCode?.identifier ?? "")
    
    
    
    func start() {
        let MainPageController = MainPageViewController.instantiate()
        let model = MainPageViewModel()
        model.coordinator = self
        model.locale = locale
        MainPageController.viewModel = model
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(MainPageController, animated: true)
    }
    func showLocations(viewController: UIViewController) {
        let locationsPage = LocationsViewController.instantiate()
        let locationsViewModel = LocationsViewModel()
        locationsViewModel.delegate = viewController as? any MainPageViewControllerDelegate
        locationsViewModel.coordinator = self
        locationsViewModel.locale = locale
        locationsPage.viewModel = locationsViewModel
        navigationController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.pushViewController(locationsPage, animated: true)
    }

    func weatherPresent(location: String, coords: Coords) {
        let weatherPage = WeatherPreviewViewController()
        let weatherViewModel = WeatherPreviewViewModel()
        weatherViewModel.location = location
        weatherViewModel.coords = coords
        weatherViewModel.locale = locale
        weatherPage.viewModel = weatherViewModel
        navigationController.present(weatherPage, animated: true)
    }
    func backToMain() {
        navigationController.popToRootViewController(animated: true)
    }
}

