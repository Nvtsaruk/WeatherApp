import UIKit

final class LocationsTableViewCell: UITableViewCell {

    @IBOutlet private weak var locationView: UIView!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var skyLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var minMaxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationView.layer.cornerRadius = 8
        locationView.clipsToBounds = true
        
        placeLabel.addShadow()
        skyLabel.addShadow()
        tempLabel.addShadow()
        minMaxTempLabel.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    func configure(locationName: String, backImage: String, sky: String, temp: Double, minMax: String) {
        placeLabel.text = locationName
        backgroundImage.image = UIImage(named: backImage)
        skyLabel.text = sky
        tempLabel.text = String(Int(temp)) + WeatherScreenLocalization.tempSign.string
        minMaxTempLabel.text = minMax
    }
}


