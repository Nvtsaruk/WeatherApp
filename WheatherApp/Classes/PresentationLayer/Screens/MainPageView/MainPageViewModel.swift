import UIKit
protocol MainPageViewModelProtocol {
    var updateClosure:( ()->Void )? { get set }
    var locale: LocaleEnum? { get }
    var weatherData: [WeatherModel] { get }
    func showLocations(viewController: UIViewController)
    func getCityArray()
    func addObserver()
}

final class MainPageViewModel: MainPageViewModelProtocol {
    var updateClosure: (() -> Void)?
    
    var coordinator: MainCoordinator?
    var city: String?
    var locale: LocaleEnum?
    
    var weatherData: [WeatherModel] = [] {
        didSet {
            updateClosure?()
        }
    }
    
    func addObserver() {
        DatabaseService.shared.addObserver(self)
    }
    
    func showLocations(viewController: UIViewController) {
        coordinator?.showLocations(viewController: viewController)
    }
    
    func getCityArray() {
        weatherData = DatabaseService.shared.getAllWeather()
    }
}

extension MainPageViewModel: DatabaseServiceObserver {
    func dataBaseUpdated() {
        getCityArray()
    }
}
