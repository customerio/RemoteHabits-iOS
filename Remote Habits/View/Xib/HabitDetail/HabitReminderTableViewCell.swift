//
//  HabitReminderTableViewCell.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import UIKit

class HabitReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var toTimeText: UITextField!
    @IBOutlet weak var fromTimeText: UITextField!
    @IBOutlet weak var frequencyText: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var mainCellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCellView.layer.cornerRadius = 13
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
