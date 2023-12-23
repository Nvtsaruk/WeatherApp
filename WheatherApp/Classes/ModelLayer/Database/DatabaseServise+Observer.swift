protocol DatabaseServiceObserver: AnyObject {
    func dataBaseUpdated()
}

extension DatabaseService {
    struct Observation {
        weak var observer: DatabaseServiceObserver?
    }
}

extension DatabaseService {
    func baseDidChange() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }
            observer.dataBaseUpdated()
        }
    }
}

extension DatabaseService {
    func addObserver(_ observer: DatabaseServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }
    
    func removeObserver(_ observer: DatabaseServiceObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
