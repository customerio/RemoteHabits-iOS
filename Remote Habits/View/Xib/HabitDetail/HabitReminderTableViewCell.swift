import UIKit

class HabitReminderTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var toTimeText: UITextField!
    @IBOutlet var fromTimeText: UITextField!
    @IBOutlet var frequencyText: UITextField!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var frequencyLabel: UILabel!
    @IBOutlet var headerTitle: UILabel!
    @IBOutlet var mainCellView: UIView!

    var habitData: Habits?
    var actionHandler: DashboardDetailTimeHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let textFields = [frequencyText, fromTimeText, toTimeText]
        setUpCellView()
        setUpTextFieldsTimePicker(textFields)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillHabitDetailData() {
        frequencyText.text = "\(habitData?.frequency ?? 0)"
        fromTimeText.text = habitData?.startTime?.formatDateToString(inFormat: .time12Hour) ?? Date()
            .formatDateToString(inFormat: .time12Hour)
        toTimeText.text = habitData?.endTime?.formatDateToString(inFormat: .time12Hour) ?? Date()
            .formatDateToString(inFormat: .time12Hour)
    }

    func setUpCellView() {
        mainCellView.setCornerRadius(.radius13)
        mainCellView.backgroundColor = Color.PrimaryBackground
        frequencyLabel.textColor = Color.LabelLightGray
        toLabel.textColor = Color.LabelLightGray
        fromLabel.textColor = Color.LabelLightGray
        fromTimeText.backgroundColor = Color.MediumGray
        toTimeText.backgroundColor = Color.MediumGray
        fromTimeText.textColor = Color.LabelLightGray
        toTimeText.textColor = Color.LabelLightGray
        selectionStyle = .none
    }

    func setUpTextFieldsTimePicker(_ textFields: [UITextField?]) {
        for textField in textFields {
            // Add time picker view to Start time and end time
            if textField == fromTimeText || textField == toTimeText {
                let datePickerST = UIDatePicker()
                datePickerST.datePickerMode = .time
                datePickerST.setDate(Date(), animated: true)

                var selector = #selector(updateStartTime(_:))
                if textField == toTimeText {
                    selector = #selector(updateEndTime(_:))
                }
                datePickerST.addTarget(self, action: selector, for: .valueChanged)
                datePickerST.preferredDatePickerStyle = .wheels
                textField?.inputView = datePickerST
            }

            // Done button accessory view for all textfields

            let doneToolbar = Toolbar().standardToolBar([.done: #selector(hideKeyboard)])
            textField?.inputAccessoryView = doneToolbar

            // Set delegate for all textfields
            textField?.delegate = self
        }
    }

    @objc func hideKeyboard() {
        endEditing(true)
    }

    @objc func updateStartTime(_ sender: UIDatePicker) {
        fromTimeText?.text = formatDateForDisplay(date: sender.date)
        updateHabitTime()
    }

    @objc func updateEndTime(_ sender: UIDatePicker) {
        toTimeText.text = formatDateForDisplay(date: sender.date)
        updateHabitTime()
    }

    func updateHabitTime(withFreq freq: Int? = nil) {
        let frequency = freq ?? Int(frequencyText.text ?? "0")
        let selectedHabit = SelectedHabitData(title: habitData?.title, frequency: frequency,
                                              startTime: fromTimeText.text ?? "", endTime: toTimeText.text ?? "",
                                              id: Int(habitData?.id ?? 0), isEnabled: habitData?.isEnabled)

        actionHandler?.updateTime(with: selectedHabit)
    }

    func formatDateForDisplay(date: Date) -> String {
        date.formatDateToString(inFormat: .time12Hour)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        textField is FrequencyTextField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField is FrequencyTextField {
            updateHabitTime(withFreq: Int(textField.text ?? "0") ?? 0)
        }
    }

    @IBAction func startTimeBeginEditing(_ sender: UITextField) {}
}

class FrequencyTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
