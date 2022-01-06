import UIKit

class HabitTableViewCell: UITableViewCell {
  
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var habitSwitch: UISwitch!
    @IBOutlet weak var habitSubTitle: UILabel!
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var habitIcon: UIImageView!
    @IBOutlet weak var mainCellView: UIView!
    var actionType : ActionType?
    var habitData : Habits?
    
    var actionDelegate: RHDashboardActionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainCellView.backgroundColor = RHColor.WhiteBackground
        habitTitle.textColor = RHColor.LabelBlack
        habitSubTitle.textColor = RHColor.LabelLightGray
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
        
        habitIcon.image = UIImage(named: habitData.icon ?? RHConstants.kLogo)
        habitTitle.text = habitData.title
        habitSubTitle.text = habitData.subtitle
        actionType = habitData.actionType
        let type = habitData.type
        switch type {
        case .toggleSwitch :
            habitSwitch.isHidden = false
            actionButton.isHidden = true
            habitSwitch.setOn(habitData.isEnabled, animated: true)
        case .button:
            actionButton.isHidden = false
            habitSwitch.isHidden = true
            actionButton.isEnabled = habitData.isEnabled
            actionButton.setTitle(habitData.actionName, for: .normal)
        case .none :
            actionButton.setTitle(RHConstants.kEmptyValue, for: .normal)
            habitSwitch.isHidden = true
            actionButton.isHidden = true
        }
    }

    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
        let selectedHabitData = SelectedHabitData(title: habitData?.title, frequency: Int(habitData?.frequency ?? 0), startTime: habitData?.startTime?.formatDateToString(inFormat: .time12Hour), endTime: habitData?.endTime?.formatDateToString(inFormat: .time12Hour), id: Int(habitData?.id ?? 0), isEnabled: sender.isOn)
        
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
