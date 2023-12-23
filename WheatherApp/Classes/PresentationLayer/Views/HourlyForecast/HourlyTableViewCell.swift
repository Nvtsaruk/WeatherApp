import UIKit

final class HourlyTableViewCell: UITableViewCell {

    @IBOutlet private weak var hourlyView: UIView!
    @IBOutlet private weak var hourlyCollectionView: UICollectionView!
    @IBOutlet private weak var hourlyLabel: UILabel!
    
    var weatherData: [Hourly]? {
        didSet {
            hourlyCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20))
    }
    
    private func setupUI() {
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        let collectionNib = UINib(nibName: XibNames.hourlyCollection.name, bundle: nil)
        hourlyCollectionView.register(collectionNib, forCellWithReuseIdentifier: XibNames.hourlyCollection.name)
        hourlyView.backgroundColor = UIColor(cgColor: CGColor(gray: 0.25, alpha: 0.3))
        hourlyView.layer.cornerRadius = 16
        hourlyView.clipsToBounds = true
        hourlyLabel.text = WeatherScreenLocalization.hourly.string
    }
}

extension HourlyTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hourlyCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: XibNames.hourlyCollection.name, for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell()}
        guard let time = weatherData?[indexPath.row].dt,
              let icon = weatherData?[indexPath.row].weather.first?.icon.getIcon(),
              let temp =  weatherData?[indexPath.row].temp else { return UICollectionViewCell()}
        let hour = WeatherDateFormatter.shared.getHour(date: Date(timeIntervalSince1970: TimeInterval(time)))
        hourlyCollectionCell.configure(hour: hour, icon: icon, temp: temp)
        return hourlyCollectionCell
    }
}
extension HourlyTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 6) - 2
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
