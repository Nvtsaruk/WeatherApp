import Foundation

struct Coords {
    let lon: Double
    let lat: Double
}
protocol WeatherViewModelProtocol {
    var updateClosure:( ()->Void )? { get set }
    var locale: LocaleEnum? { get }
    var weatherData: WeatherModel? { get }
    var isLoading: Bool { get }
    var connection: Bool { get }
    var saveTime: Date? { get }
    func getData()
    func getMinMax(tempArr:[Hourly]) -> String
}

final class WeatherViewModel: WeatherViewModelProtocol {
    var updateClosure: (() -> Void)?
    var coordinator: MainCoordinator?
    var location: String = ""
    var coords: Coords?
    var locale: LocaleEnum?
    var saveTime: Date?
    var connection: Bool = Connectivity.sharedInstance.isReachable
    var isLoading: Bool = false {
        didSet {
            updateClosure?()
        }
    }
    var weatherData: WeatherModel? {
        didSet {
            updateClosure?()
        }
    }
    
    func getData() {
        isLoading = true
        if self.location == "Current" {
            if connection {
                getLocation()
            } else {
                saveTime = UserDefaults.standard.object(forKey: "SaveTime") as? Date
                updateClosure?()
                getFromDatabase(location: self.location)
            }
        } else {
            if connection {
                getWeather(lat: coords?.lat ?? 0, lon: coords?.lon ?? 0)
            } else {
                getFromDatabase(location: self.location)
            }
        }
    }

    private func getLocation() {
        LocationManager.shared.getCurrentLocation{ [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
        }
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
    
    private func getWeather(lat: Double, lon: Double) {
        APIService.getData(WeatherModel.self, url: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&lang=\(locale?.getLocale() ?? "")&units=\(locale?.getUnits() ?? "")&exclude=minutely&appid=3227ae00481280e44d00c1653fd156cb") { result in
                switch result {
                    case .success(let data):
                        self.weatherData = data
                        self.getCityName(lat: lat, lon: lon)
                    case .failure(let error):
                        ErrorHandler.shared.handleError(error: error)
                }
            }
    }
    
    private func getCityName(lat: Double, lon: Double) {
            APIService.getData(CoordToPlaceArr.self, url: "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=1&appid=3227ae00481280e44d00c1653fd156cb") { result in
                switch result {
                    case .success(let data):
                        self.weatherData?.timezone = data[0].local_names?[self.locale?.getLocale() ?? ""] ?? ""
                        self.addBase()
                    case .failure(let error):
                        ErrorHandler.shared.handleError(error: error)
                }
            }
        isLoading = false
    }
    
    func addBase() {
        if !(UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
            guard let data = weatherData else { return }
            DatabaseService.shared.createDatabase(location: self.location, weather: data)
           UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.set(Date(), forKey: "SaveTime")
           UserDefaults.standard.synchronize()
        } else {
            guard let data = weatherData else { return }
            DatabaseService.shared.updateWeather(location: self.location, weather: data)
            UserDefaults.standard.set(Date(), forKey: "SaveTime")
           UserDefaults.standard.synchronize()
        }
        
    }
    
    func getFromDatabase(location: String) {
        self.weatherData = DatabaseService.shared.getDatabaseWeather(locationName: location)
        self.isLoading = false
    }
}
