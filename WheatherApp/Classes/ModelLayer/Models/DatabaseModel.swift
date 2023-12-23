import RealmSwift
import Foundation

final class DatabaseLocation: Object {
    @Persisted(primaryKey: true) var locationID: String
    @Persisted var weather: DatabaseWeatherModel? = nil
    
    convenience init(location: String, weather: DatabaseWeatherModel) {
        self.init()
        self.weather = weather
    }
}

final class DatabaseWeatherModel: Object {
    @Persisted var lat: Double
    @Persisted var lon: Double
    @Persisted var timezone: String
    @Persisted var current: DatabaseCurrent? = nil
    @Persisted var hourly: List<DatabaseHourly>
    @Persisted var daily: List<DatabaseDaily>
    
    convenience init(_ model: WeatherModel) {
        self.init()
        self.lat = model.lat
        self.lon = model.lon
        self.timezone = model.timezone
    }
}

final class DatabaseCurrent: Object {
    @Persisted var dt: Int
    @Persisted var temp: Double
    @Persisted var weather: List<DatabaseWeather>
    
    convenience init(_ model: WeatherModel) {
        self.init()
        self.dt = model.current.dt
        self.temp = model.current.temp
    }
}
final class DatabaseHourly: Object {
    @Persisted var dt: Int
    @Persisted var temp: Double
    @Persisted var weather: List<DatabaseWeather>
    
    convenience init(dt: Int, temp: Double, weather: List<DatabaseWeather>) {
        self.init()
        self.dt = dt
        self.temp = temp
        self.weather = weather
    }
}
final class DatabaseDaily: Object {
    @Persisted var dt: Int
    @Persisted var temp: DatabaseTemp? = nil
    @Persisted var weather: List<DatabaseWeather>
    
    convenience init(dt: Int, temp: DatabaseTemp, weather: List<DatabaseWeather>) {
        self.init()
        self.dt = dt
        self.temp = temp
        self.weather = weather
    }
}
final class DatabaseWeather: Object {
    @Persisted var id: Int
    @Persisted var main: String
    @Persisted var desc: String
    @Persisted var icon: String
    
    convenience init(_ model: Weather) {
        self.init()
        self.id = model.id
        self.main = model.main
        self.desc = model.description
        self.icon = model.icon.rawValue
    }
}

final class DatabaseTemp: Object {
    @Persisted var min: Double
    @Persisted var max: Double
    
    convenience init(_ model: Temp) {
        self.init()
        self.min = model.min
        self.max = model.max
    }
}
