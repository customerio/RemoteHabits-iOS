//
//  HabitDetailToggleTableViewCell.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import UIKit

class HabitDetailToggleTableViewCell: UITableViewCell {

    @IBOutlet weak var habitSwitch: UISwitch!
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var mainCellView: UIView!
    var actionHandler : RHDashboardDetailActionHandler?
    var habitData : Habits?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCellView.layer.cornerRadius = 13
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillHabitsData() {
        habitSwitch.isOn = habitData?.isEnabled ?? false
    }
    
    @IBAction func habitSwitchValueChanged(_ sender: UISwitch) {
        actionHandler?.toggleHabit(toValue: sender.isOn)
    }
}
