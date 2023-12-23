enum XibNames {
    case hourly
    case hourlyCollection
    case weekly
    case day
    case location
    case search
    
    var name: String {
        switch self {
            case .hourly:
                return "HourlyTableViewCell"
            case .hourlyCollection:
                return "HourlyCollectionViewCell"
            case .weekly:
                return "WeeklyTableViewCell"
            case .day:
                return "DayTableViewCell"
            case .location:
                return "LocationsTableViewCell"
            case .search:
                return "SearchTableViewCell"
        }
    }
}
