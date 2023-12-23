import UIKit

final class DayTableViewCell: UITableViewCell {

    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(day: String, iconImage: String, min: Double, max: Double) {
        dayLabel.text = day
        icon.image = UIImage(systemName: iconImage)?.withRenderingMode(.alwaysOriginal)
        minTempLabel.text = String(Int(min)) + WeatherScreenLocalization.tempSign.string
        maxTempLabel.text = String(Int(max)) + WeatherScreenLocalization.tempSign.string
    }
}
