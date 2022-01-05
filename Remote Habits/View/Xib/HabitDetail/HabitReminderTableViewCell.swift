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

    var actionHandler: RHDashboardDetailTimeHandler?
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

        let numberToolbar = UIToolbar()
        numberToolbar.barStyle = .default
        numberToolbar
            .items =
            [UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self,
                             action: #selector(hideKeyboard))]
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

    @objc func updateStartTime(_ sender: UIDatePicker) {
        fromTimeText?.text = formatDateForDisplay(date: sender.date)
        actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                  toTime: toTimeText.text ?? "",
                                  andFreq: Int(frequencyText.text ?? "0") ?? 0)
    }

    @objc func updateEndTime(_ sender: UIDatePicker) {
        toTimeText.text = formatDateForDisplay(date: sender.date)
        actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                  toTime: toTimeText.text ?? "",
                                  andFreq: Int(frequencyText.text ?? "0") ?? 0)
    }

    func formatDateForDisplay(date: Date) -> String {
        date.formatDateToString(inFormat: .time12Hour)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        textField.tag == 1001 ? true : false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1001 {
            actionHandler?.updateTime(fromTime: fromTimeText.text ?? "",
                                      toTime: toTimeText.text ?? "",
                                      andFreq: Int(textField.text ?? "0") ?? 0)
        }
    }

    @IBAction func startTimeBeginEditing(_ sender: UITextField) {}
}
