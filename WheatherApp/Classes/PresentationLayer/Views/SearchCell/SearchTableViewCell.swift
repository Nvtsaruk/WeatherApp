import UIKit

final class SearchTableViewCell: UITableViewCell {

    @IBOutlet private weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(label: String) {
        locationLabel.text = label
    }
}
