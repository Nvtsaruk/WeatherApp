protocol WeatherPreviewModelProtocol {
    func getData()
    var weatherData: WeatherModel? { get }
    var updateClosure:( ()->Void )? { get set }
    func getMinMax(tempArr:[Hourly]) -> String
    func addBase()
}

final class WeatherPreviewViewModel: WeatherPreviewModelProtocol {
    var updateClosure: (() -> Void)?
    
    var coordinator: MainCoordinator?
    var location: String = ""
    var coords: Coords?
    var locale: LocaleEnum?
    var weatherData: WeatherModel? {
        didSet {
            updateClosure?()
        }
    }
    
    func getData() {
        getWeather(lat: coords?.lat ?? 0, lon: coords?.lon ?? 0)
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
                    case .failure(let error):
                        ErrorHandler.shared.handleError(error: error)
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
    
    func addBase() {
            guard let data = weatherData else { return }
            DatabaseService.shared.createDatabase(location: self.location, weather: data)
    }
}
