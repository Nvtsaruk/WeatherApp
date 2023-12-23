import RealmSwift
final class DatabaseService {
    static var shared = DatabaseService()
    private init() {}
    
    var observations = [ObjectIdentifier: Observation] ()
    
    let realm = try! Realm()
    
    func createDatabase(location: String, weather: WeatherModel) {
        let dbLocation = DatabaseLocation()
        dbLocation.locationID = location
        let modelToDatabase = ModelToDatabase(weather: weather)
        dbLocation.weather = modelToDatabase.modelToDatabase()
        try! realm.write {
            realm.add(dbLocation)
        }
        baseDidChange()
    }
    
    func updateWeather(location: String, weather: WeatherModel) {
        let dbLocation = realm.objects(DatabaseLocation.self)
        let locationForUpdate = dbLocation.where { $0.locationID == location }
        let modelToDatabase = ModelToDatabase(weather: weather)
        try! realm.write {
            locationForUpdate.first?.weather = modelToDatabase.modelToDatabase()
        }
    }
    
    func getAllWeather() -> [WeatherModel] {
        var allWeather: [WeatherModel] = []
        let dbLocation = realm.objects(DatabaseLocation.self)
        dbLocation.forEach{ weather in
            guard let weatherFormModel = weather.weather else { return }
            let dbMap = DatabaseToModel(dbModel: weatherFormModel, locationID: weather.locationID)
            guard let weatherModel = dbMap.databaseToModel() else { return }
            allWeather.append(weatherModel)
        }
        return allWeather
    }
    
    func getDatabaseWeather(locationName: String) -> WeatherModel? {
        let dbLocation = realm.objects(DatabaseLocation.self)
        let currentLocation = dbLocation.where{
            $0.locationID == locationName
        }
        guard let weather = currentLocation.first?.weather else { return nil }
        let dbMap = DatabaseToModel(dbModel: weather, locationID: locationName)
        return dbMap.databaseToModel()
    }
 
    func deleteLocation(locationName: String) {
        try! realm.write {
            let dbLocations = realm.objects(DatabaseLocation.self).where {
                $0.weather.timezone == locationName
            }
            realm.delete(dbLocations)
        }
        baseDidChange()
    }
    
    func getLocationsNumber() -> Int {
        let dbLocations = realm.objects(DatabaseLocation.self)
        return dbLocations.count
    }
}
