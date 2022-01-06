import UIKit

class HabitAddInfoTableViewCell: UITableViewCell {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var mainCellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCellView.customiseView()
        descriptionLabel.textColor = RHColor.LabelLightGray
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
