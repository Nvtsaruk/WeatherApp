import UIKit

final class WeeklyTableViewCell: UITableViewCell {
    
    var weatherData: [Daily]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var weeklyView: UIView!
    @IBOutlet private weak var weeklyLabel: UILabel!
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        let dayNib = UINib(nibName: XibNames.day.name, bundle: nil)
        tableView.register(dayNib, forCellReuseIdentifier: XibNames.day.name)
        weeklyView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.25, alpha: 0.3))
        weeklyView.layer.cornerRadius = 16
        weeklyView.clipsToBounds = true
        weeklyLabel.text = WeatherScreenLocalization.weekly.string
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10))
    }
}

extension WeeklyTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dayCell = tableView.dequeueReusableCell(withIdentifier: XibNames.day.name) as? DayTableViewCell else { return UITableViewCell() }
        guard let day = weatherData?[indexPath.row].dt,
              let icon = weatherData?[indexPath.row].weather.first?.icon.getIcon(),
              let min = weatherData?[indexPath.row].temp.min,
              let max = weatherData?[indexPath.row].temp.max
        else { return UITableViewCell()}
        let dayName = WeatherDateFormatter.shared.getDay(day: Date(timeIntervalSince1970: TimeInterval(day)))
        dayCell.configure(day: dayName, iconImage: icon, min: min, max: max)
        return dayCell
    }
}

