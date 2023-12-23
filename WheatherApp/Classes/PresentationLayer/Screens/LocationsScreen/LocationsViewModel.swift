import Foundation

protocol LocationsViewModelProtocol {
    var locale: LocaleEnum? { get }
    var weatherData: [WeatherModel] { get }
    var updateClosure:( ()->Void )? { get set }
    var location: CoordToPlaceArr? { get }
    func removeCity(location: String)
    func search(item: String)
    func getData()
    func getMinMax(tempArr:[Hourly]) -> String
    func addObserver()
    func presentWeather(id: Int)
    func backToMain(page: Int)
}

final class LocationsViewModel: LocationsViewModelProtocol {
    var updateClosure: (() -> Void)?
    var lastScheduledSearch: Timer?
    var coordinator: MainCoordinator?
    weak var delegate: MainPageViewControllerDelegate?
    var locale: LocaleEnum?
    var location: CoordToPlaceArr? {
        didSet {
            updateClosure?()
        }
    }
    
    var weatherData: [WeatherModel] = [] {
        didSet {
            updateClosure?()
        }
    }
    
    func addObserver() {
        DatabaseService.shared.addObserver(self)
    }
    
    func getData() {
        self.weatherData = DatabaseService.shared.getAllWeather()
    }
    
    func removeCity(location: String) {
        DatabaseService.shared.deleteLocation(locationName: location)
    }
    
    func getMinMax(tempArr:[Hourly]) -> String {
        var tempSet: [Double] = []
        tempArr.forEach{ temp in
            tempSet.append(temp.temp)
        }
        tempSet = tempSet.sorted { $0 < $1 }
        guard let min = tempSet.first,
              let max = tempSet.last else { return ""}
        let resultString = "\(WeatherScreenLocalization.max.string).: \(Int(max))°, \(WeatherScreenLocalization.min.string).: \(Int(min))°"
        return resultString
    }
    
    func search(item: String) {
        lastScheduledSearch?.invalidate()
        lastScheduledSearch = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchQuery(_:)), userInfo: item, repeats: false)
    }
    
    @objc private func searchQuery(_ timer: Timer) {
        guard let text = timer.userInfo else { return }
        let url = "https://api.openweathermap.org/geo/1.0/direct?q=\(((text as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))&limit=5&appid=3227ae00481280e44d00c1653fd156cb"
        APIService.getData(CoordToPlaceArr.self, url: url) { result in
            switch result {
                case .success(let data):
                    self.location = data
                case .failure(let error):
                    ErrorHandler.shared.handleError(error: error)
            }
        }
    }
    
    func presentWeather(id: Int) {
        let location = location?[id].name
        let coords = Coords(lon: self.location?[id].lon ?? 0, lat: self.location?[id].lat ?? 0)
        coordinator?.weatherPresent(location: location ?? "", coords: coords)
    }
    
    func backToMain(page: Int) {
        delegate?.setPage(page: page)
        coordinator?.backToMain()
    }


}

extension LocationsViewModel: DatabaseServiceObserver {
    func dataBaseUpdated() {
        updateClosure?()
        getData()
    }
}
