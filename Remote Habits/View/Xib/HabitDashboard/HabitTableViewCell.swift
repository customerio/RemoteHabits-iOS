import UIKit

class HabitTableViewCell: UITableViewCell {
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var habitSwitch: UISwitch!
    @IBOutlet var habitSubTitle: UILabel!
    @IBOutlet var habitTitle: UILabel!
    @IBOutlet var habitIcon: UIImageView!
    @IBOutlet var mainCellView: UIView!
    var actionType: ActionType?
    var habitData: Habits?

    weak var actionDelegate: DashboardActionHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        mainCellView.backgroundColor = Color.PrimaryBackground
        habitTitle.textColor = Color.LabelBlack
        habitSubTitle.textColor = Color.LabelLightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        mainCellView.setCornerRadius(.radius13)
        // Configure the view for the selected state
    }

    func fillHabitsData() {
        guard let habitData = habitData else {
            return
        }

        habitIcon.image = UIImage(named: habitData.icon ?? Constants.kLogo)
        habitTitle.text = habitData.title
        habitSubTitle.text = habitData.subtitle
        actionType = habitData.actionType
        let type = habitData.type
        switch type {
        case .toggleSwitch:
            habitSwitch.isHidden = false
            actionButton.isHidden = true
            habitSwitch.setOn(habitData.isEnabled, animated: true)
        case .button:
            actionButton.isHidden = false
            habitSwitch.isHidden = true
            actionButton.isEnabled = habitData.isEnabled
            actionButton.setTitle(habitData.actionName, for: .normal)
        case .none:
            actionButton.setTitle(Constants.kEmptyValue, for: .normal)
            habitSwitch.isHidden = true
            actionButton.isHidden = true
        }
    }

    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
        let selectedHabitData = SelectedHabitData(title: habitData?.title, frequency: Int(habitData?.frequency ?? 0),
                                                  startTime: habitData?.startTime?
                                                      .formatDateToString(inFormat: .time12Hour),
                                                  endTime: habitData?.endTime?
                                                      .formatDateToString(inFormat: .time12Hour),
                                                  id: Int(habitData?.id ?? 0), isEnabled: sender.isOn)

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
