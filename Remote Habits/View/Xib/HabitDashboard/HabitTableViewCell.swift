//
//  HabitTableViewswift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import UIKit

class HabitTableViewCell: UITableViewCell {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var habitSwitch: UISwitch!
    @IBOutlet weak var habitSubTitle: UILabel!
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var habitIcon: UIImageView!
    @IBOutlet weak var mainCellView: UIView!
    var actionType : HabitActionType?
    var habitData : HabitData?
    
    var actionDelegate: RHDashboardActionHandler?
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
                habitSwitch.setOn(habitData.habitDetail?.isHabitEnabled ??  false, animated: true)
            }
            else if type == .button {
                actionButton.isHidden = false
                habitSwitch.isHidden = true
                actionButton.isEnabled = habitData.habitDetail?.isHabitEnabled ?? true
                actionButton.setTitle(habitData.habitDetail?.actionButtonValue, for: .normal)
            }
        }
        else {
            actionButton.setTitle(RHConstants.kEmptyValue, for: .normal)
            habitSwitch.isHidden = true
            actionButton.isHidden = true
        }
    }
    
    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
//        let selectedHabitData = SelectedHabitData(title: habitData?.title, frequency: habitData., startTime: <#T##Int?#>, endTime: <#T##Int?#>)
    }
    
    @IBAction func habitActionButtonTapped(_ sender: UIButton) {
        switch (actionType) {
        case .switchWorkspace :
            actionDelegate?.switchWorkspace()
        case .logout :
            actionDelegate?.logoutUser()
        case .login :
            actionDelegate?.loginUser()
        default:
            break
            
        }
    }
}
