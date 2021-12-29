//
//  HabitReminderTableViewCell.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 30/11/21.
//

import UIKit

class HabitReminderTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var toTimeText: UITextField!
    @IBOutlet weak var fromTimeText: UITextField!
    @IBOutlet weak var frequencyText: FrequencyTextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var mainCellView: UIView!
    
    var actionHandler : RHDashboardDetailTimeHandler?
    var habitData : Habits?
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCellView.layer.cornerRadius = 13
        selectionStyle = .none
        // Initialization code
        setUpTextFieldsTimePicker()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillHabitDetailData() {
        frequencyText.text = "\(habitData?.frequency ?? 0)"
        fromTimeText.text = habitData?.startTime?.formatDateToString(inFormat: .time12Hour)
        toTimeText.text = habitData?.endTime?.formatDateToString(inFormat: .time12Hour)
    }
    func setUpTextFieldsTimePicker() {
        
        let datePickerST = UIDatePicker()
        datePickerST.datePickerMode = .time
        datePickerST.setDate(Date(), animated: true)
        datePickerST.addTarget(self, action: #selector(updateStartTime(_:)), for: .valueChanged)
        fromTimeText.inputView = datePickerST
        
        let datePickerET = UIDatePicker()
        datePickerET.datePickerMode = .time
        datePickerET.setDate(Date(), animated: true)
        datePickerET.addTarget(self, action: #selector(updateEndTime(_:)), for: .valueChanged)
        toTimeText.inputView = datePickerET
        
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(hideKeyboard))]
        numberToolbar.sizeToFit()
        frequencyText.inputAccessoryView = numberToolbar
        
        fromTimeText.delegate = self
        toTimeText.delegate = self
        frequencyText.delegate = self
    }
    
    @objc func hideKeyboard() {
        frequencyText.resignFirstResponder()
    }
    
    @objc func updateStartTime(_ sender : UIDatePicker) {
        fromTimeText?.text = formatDateForDisplay(date: sender.date)
        updateHabitTime()
    }
    
    @objc func updateEndTime(_ sender : UIDatePicker) {
        toTimeText.text = formatDateForDisplay(date: sender.date)
        updateHabitTime()
    }
    
    func updateHabitTime(withFreq freq : Int? = nil) {
        let frequency = freq ?? Int(frequencyText.text ?? "0")
        let selectedHabit = SelectedHabitData(title: habitData?.title, frequency: frequency, startTime: fromTimeText.text ?? "", endTime: toTimeText.text ?? "", id: Int(habitData?.id ?? 0), isEnabled: habitData?.isEnabled)
        
        actionHandler?.updateTime(with: selectedHabit)
    }
    
    func formatDateForDisplay(date: Date) -> String {
        return date.formatDateToString(inFormat: .time12Hour)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ((textField as? FrequencyTextField) != nil) ? true : false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((textField as? FrequencyTextField) != nil) {
            updateHabitTime(withFreq: Int(textField.text ?? "0") ?? 0)
        }
    }
    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        
    }
    
}
 
class FrequencyTextField : UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
