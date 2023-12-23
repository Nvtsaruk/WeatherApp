struct WeatherModel: Decodable {
    let locationID: String?
    let lat: Double
    let lon: Double
    var timezone: String
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Daily: Decodable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: WeatherIcons
}

struct Temp: Decodable {
    let min: Double
    let max: Double
    
    init(db: DatabaseTemp) {
        self.min = db.min
        self.max = db.max
    }
}

