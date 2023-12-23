final class DatabaseToModel {
    let dbModel: DatabaseWeatherModel
    let locationID: String
    
    init(dbModel: DatabaseWeatherModel, locationID: String) {
        self.dbModel = dbModel
        self.locationID = locationID
    }
    func databaseToModel() -> WeatherModel? {
        guard let currentDb = dbModel.current,
              let current = databaseToCurrentModel(db: currentDb)
        else { return nil}
        var hourlyModel: [Hourly] = []
        dbModel.hourly.forEach{ hourItem in
            guard let dbWeather = hourItem.weather.first,
                  let weather = databaseToWeatherModel(db: dbWeather)
            else { return }
            var weatherArr: [Weather] = []
            weatherArr.append(weather)
            let hourly = Hourly(dt: hourItem.dt, temp: hourItem.temp, weather: weatherArr)
            hourlyModel.append(hourly)
        }
        var dailyModel: [Daily] = []
        dbModel.daily.forEach{ dailyItem in
            guard let dbWeather = dailyItem.weather.first,
                  let weather = databaseToWeatherModel(db: dbWeather)
            else { return }
            var weatherArr: [Weather] = []
            weatherArr.append(weather)
            let daily = Daily(dt: dailyItem.dt, temp: Temp(db: dailyItem.temp ?? DatabaseTemp()), weather: weatherArr)
            dailyModel.append(daily)
        }
        let weatherModel = WeatherModel(locationID: locationID, lat: dbModel.lat, lon: dbModel.lon, timezone: dbModel.timezone, current: current, hourly: hourlyModel, daily: dailyModel)

        return weatherModel
    }
    
    private func databaseToCurrentModel(db: DatabaseCurrent) -> Current? {
        guard let dbWeather = db.weather.first,
              let weather = databaseToWeatherModel(db: dbWeather)
        else { return nil}
        var weatherArr: [Weather] = []
        weatherArr.append(weather)
        let current = Current(dt: db.dt, temp: db.temp, weather: weatherArr)
        return current
    }
    
    private func databaseToWeatherModel(db: DatabaseWeather) -> Weather? {
        let currentWeather = Weather(id: db.id, main: db.main, description: db.desc, icon: WeatherIcons(rawValue: (db.icon)) ?? WeatherIcons.clearSky)
        return currentWeather
    }
}

final class ModelToDatabase {
    let weather: WeatherModel
    
    init(weather: WeatherModel) {
        self.weather = weather
    }
    
    func modelToDatabase() -> DatabaseWeatherModel {
        let dbWeather = DatabaseWeatherModel(weather)
        let dbCurrent = DatabaseCurrent(weather)
        guard let currentWeather = weather.current.weather.first else { return DatabaseWeatherModel()}
        let dbCurrentWeather = DatabaseWeather(currentWeather)
        dbCurrent.weather.append(dbCurrentWeather)
        dbWeather.current = dbCurrent
        weather.hourly.forEach{ hourItem in
            let dbHourly = dbHourlyCreate(hourItem: hourItem)
            dbWeather.hourly.append(dbHourly)
        }
        weather.daily.forEach{ dailyItem in
            let dbDaily = dbDailyCreate(dailyItem: dailyItem)
            dbWeather.daily.append(dbDaily)
        }
        return dbWeather
    }
    private func dbHourlyCreate(hourItem: Hourly) -> DatabaseHourly {
        let dbHourly = DatabaseHourly()
        guard let hourlyWeather = hourItem.weather.first else { return DatabaseHourly()}
        dbHourly.dt = hourItem.dt
        dbHourly.temp = hourItem.temp
        let dbHourlyWeather = DatabaseWeather(hourlyWeather)
        dbHourly.weather.append(dbHourlyWeather)
        return dbHourly
    }
    private func dbDailyCreate(dailyItem: Daily) -> DatabaseDaily {
        let dbDaily = DatabaseDaily()
        guard let dailyWeather = dailyItem.weather.first else { return DatabaseDaily()}
        dbDaily.dt = dailyItem.dt
        dbDaily.temp = DatabaseTemp(dailyItem.temp)
        let dbDailyWeather = DatabaseWeather(dailyWeather)
        dbDaily.weather.append(dbDailyWeather)
        return dbDaily
    }
}
