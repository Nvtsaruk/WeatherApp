import Foundation
enum WeatherScreenLocalization {
    case max
    case min
    case tempSign
    case hourly
    case weekly
    case noInternet
    case lastUpdate
    
    
    var string: String {
        switch self {
            case .max:
                return NSLocalizedString("maxTemp", comment: "")
            case .min:
                return NSLocalizedString("minTemp", comment: "")
            case .tempSign:
                return NSLocalizedString("tempSign", comment: "")
            case .hourly:
                return NSLocalizedString("hourlyLabelText", comment: "")
            case .weekly:
                return NSLocalizedString("weeklyLabelText", comment: "")
            case .noInternet:
                return NSLocalizedString("noInternet", comment: "")
            case .lastUpdate:
                return NSLocalizedString("lastUpdate", comment: "")
        }
    }
}

enum LocationSearchLocalization {
    case title
    case searchPlaceholder
    case current
    case add
    case cancel
    
    var string: String {
        switch self {
            case .title:
                return NSLocalizedString("weather", comment: "")
            case .searchPlaceholder:
                return NSLocalizedString("weatherSearchText", comment: "")
            case .current:
                return NSLocalizedString("currentPlace", comment: "")
            case .add:
                return NSLocalizedString("add", comment: "")
            case .cancel:
                return NSLocalizedString("cancel", comment: "")
        }
    }
}

