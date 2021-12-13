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
    @IBOutlet weak var frequencyText: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var mainCellView: UIView!
    
    var actionHandler : RHDashboardDetailTimeHandler?
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
        frequencyText.tag = 1001
    }
    
    @objc func hideKeyboard() {
        frequencyText.resignFirstResponder()
    }
    
    @objc func updateStartTime(_ sender : UIDatePicker) {
        
        fromTimeText?.text = formatDateForDisplay(date: sender.date)
        actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                  toTime: toTimeText.text ?? "",
                                  andFreq: Int(frequencyText.text ?? "0") ?? 0)
    }
    
    @objc func updateEndTime(_ sender : UIDatePicker) {
        toTimeText.text = formatDateForDisplay(date: sender.date)
        actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                  toTime: toTimeText.text ?? "",
                                  andFreq: Int(frequencyText.text ?? "0") ?? 0)
    }
    
    func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.tag == 1001 ? true : false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1001 {
            actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                      toTime: toTimeText.text ?? "",
                                      andFreq: Int(textField.text ?? "0") ?? 0)
        }
    }
    
    @IBAction func startTimeBeginEditing(_ sender: UITextField) {
        
    }
    
}
 
