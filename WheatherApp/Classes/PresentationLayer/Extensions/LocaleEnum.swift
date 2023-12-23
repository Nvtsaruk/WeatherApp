enum LocaleEnum: String {
    case ru = "ru"
    case en = "en"
    
    func getLocale() -> String {
        switch self {
            case .ru:
                return "ru"
            case .en:
                return "en"
        }
    }
    func getUnits() -> String {
        switch self {
            case .ru:
                return "metric"
            case .en:
                return "imperial"
        }
    }
    func getId() -> String {
        switch self {
            case .ru:
                return "ru_RU"
            case .en:
                return "en_EN"
        }
    }
}
