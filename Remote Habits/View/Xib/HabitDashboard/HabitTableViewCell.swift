import UIKit

class HabitTableViewCell: UITableViewCell {
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var habitSwitch: UISwitch!
    @IBOutlet var habitSubTitle: UILabel!
    @IBOutlet var habitTitle: UILabel!
    @IBOutlet var habitIcon: UIImageView!
    @IBOutlet var mainCellView: UIView!
    var actionType: HabitActionType?
    var habitData: HabitData?

    weak var actionDelegate: RHDashboardActionHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        mainCellView.layer.cornerRadius = 13
        // Configure the view for the selected state
    }

    func fillData() {
        guard let habitData = habitData else {
            return
        }

        habitIcon.image = UIImage(named: habitData.icon ?? RHConstants.kLogo)
        habitTitle.text = habitData.title
        habitSubTitle.text = habitData.subTitle
        actionType = habitData.habitDetail?.actionType
        if let type = habitData.type {
            if type == .toggleSwitch {
                habitSwitch.isHidden = false
                actionButton.isHidden = true
                habitSwitch.setOn(habitData.habitDetail?.isHabitEnabled ?? false, animated: true)
            } else if type == .button {
                actionButton.isHidden = false
                habitSwitch.isHidden = true
                actionButton.isEnabled = habitData.habitDetail?.isHabitEnabled ?? true
                actionButton.setTitle(habitData.habitDetail?.actionButtonValue, for: .normal)
            }
        } else {
            actionButton.setTitle(RHConstants.kEmptyValue, for: .normal)
            habitSwitch.isHidden = true
            actionButton.isHidden = true
        }
    }

    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
        let selectedHabitData = SelectedHabitData(title: habitData?.title, frequency: habitData?.habitDetail?.frequency,
                                                  startTime: habitData?.habitDetail?.startTime,
                                                  endTime: habitData?.habitDetail?.endTime)
        actionDelegate?.toggleHabit(toValue: sender.isOn, habitData: selectedHabitData)
    }

    @IBAction func habitActionButtonTapped(_ sender: UIButton) {
        switch actionType {
        case .switchWorkspace:
            actionDelegate?.switchWorkspace()
        case .logout:
            actionDelegate?.logoutUser()
        case .login:
            actionDelegate?.loginUser()
        default:
            break
        }
    }
}
