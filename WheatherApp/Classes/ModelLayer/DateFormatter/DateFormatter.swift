import Foundation
final class WeatherDateFormatter {
    static let shared = WeatherDateFormatter()
    
    private init() {}
    
    private let hourDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH"
        return df
    }()
    
    private let dayDateFormatter: DateFormatter = {
        let locale = LocaleEnum(rawValue: Locale.current.language.languageCode?.identifier ?? "")
        let df = DateFormatter()
        df.locale = Locale(identifier: locale?.getId() ?? "")
        df.dateFormat = "E"
        return df
    }()
    private let timeInterval: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter
    }()
    
    func getHour(date: Date) -> String {
        let hourString = hourDateFormatter.string(from: date)
        return hourString
    }
    func getDay(day: Date) -> String {
        let dayString = dayDateFormatter.string(from: day)
        return dayString
    }
    func getInterval(date: TimeInterval) -> String {
        let intervalString = timeInterval.string(from: date)
        return intervalString ?? ""
    }
}
