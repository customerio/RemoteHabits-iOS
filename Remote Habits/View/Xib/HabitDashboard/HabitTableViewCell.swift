//
//  HabitTableViewCell.swift
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
    
    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
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
