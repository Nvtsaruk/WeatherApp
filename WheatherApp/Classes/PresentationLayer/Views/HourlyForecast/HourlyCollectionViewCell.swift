import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var weatherIcon: UIImageView!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(hour: String, icon: String, temp: Double) {
        hourLabel.text = hour
        weatherIcon.image = UIImage(systemName: icon)?.withRenderingMode(.alwaysOriginal)
        tempLabel.text = String(Int(temp)) + "°"
    }
}
