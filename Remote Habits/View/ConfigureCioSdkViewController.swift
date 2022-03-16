import CioTracking
import DropDown
import SkyFloatingLabelTextField
import UIKit

class ConfigureCioSdkViewController: BaseViewController {
    static func newInstance() -> ConfigureCioSdkViewController {
        UIStoryboard.getViewController(identifier: Constants.kConfigureCioSdkViewController)
    }
    // MARK: - --OUTLETS--
    @IBOutlet var trackingApiUrlText: SkyFloatingLabelTextField!
    @IBOutlet var customDeviceAttributesText: SkyFloatingLabelTextField!
    @IBOutlet var updateConfigButton: UIButton!
    @IBOutlet var bgQueueDelayText: UITextField!
    @IBOutlet var logTypeButton: UIButton!
    @IBOutlet var bgQueueMinTasksText: UITextField!
    @IBOutlet var deviceAttributesSwitch: UISwitch!
    @IBOutlet var screenViewsSwitch: UISwitch!
    @IBOutlet weak var mainView: UIView!
    
    // MARK: - --VARIABLES--
    let logTypeDropdown = DropDown()

    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFormFields()
        setUpMainView()
        configureNavigationBar(title: Constants.kConfigureSdk, hideBack: false, showLogo: false)
        configureLogLevelDropdown()
        configureTrackingApiUrl()
        configureCustomDeviceAttributesField()
        configureUpdateConfigButton()
        addDefaultBackground()
        // Do any additional setup after loading the view.
    }

    func setupFormFields() {
        trackingApiUrlText.isEnabled = false
        deviceAttributesSwitch.isEnabled = false
        customDeviceAttributesText.isEnabled = false
    }
    
    func setUpMainView() {
        mainView.setCornerRadius(.radius13)
        mainView.backgroundColor = Color.PrimaryBackground
    }
    
    func configureLogLevelDropdown() {
        logTypeButton.addColoredBorder(color: UIColor.lightGray.withAlphaComponent(0.5))
        logTypeDropdown.anchorView = logTypeButton
        logTypeDropdown.dataSource = ["debug", "info", "error"]
        logTypeDropdown.selectionAction = { [unowned self] (_: Int, item: String) in
            self.logTypeButton.setTitle(item, for: .normal)
        }
    }

    func configureUpdateConfigButton() {
        updateConfigButton.titleLabel?.font = Font.SFProTextSemiBoldMedium
        // Since Update button is always enabled so the
        // background color and text color is white, hence using UIColor.white
        updateConfigButton.setTitleColor(UIColor.white, for: .normal)
        updateConfigButton.setCornerRadius(.radius24)
        updateConfigButton.backgroundColor = Color.ButtonEnabled
    }

    func configureTrackingApiUrl() {
        setupField(trackingApiUrlText)
    }

    func configureCustomDeviceAttributesField() {
        setupField(customDeviceAttributesText)
    }

    func setupField(_ textField: SkyFloatingLabelTextField) {
        textField.placeholderColor = Color.LabelGray
        textField.disabledColor = Color.DisabledGray
        textField.textColor = UIColor.black
        textField.tintColor = Color.LabelGray
        textField.lineColor = Color.LineGray
        textField.selectedTitleColor = Color.LabelGray
        textField.selectedLineColor = Color.SelectedLineGray
        textField.delegate = self
    }

    func findLogLevel() -> CioLogLevel {
        switch logTypeButton.title(for: .normal) {
        case "debug":
            return .debug
        case "info":
            return .info
        case "error":
            return .error
        default:
            return .info
        }
    }

    // MARK: - Actions

    @IBAction func updateConfigButtonTapped(_ sender: UIButton) {
        CustomerIO.config {
            // MARK: - Enable with latest version of SDK

            /*
             $0.trackingApiUrl = !trackingApiUrlText.trimTextWithWhiteSpaces ? trackingApiUrlText.text! : ""
             $0.autoTrackDeviceAttributes = deviceAttributesSwitch.isOn
             if !customDeviceAttributesText.trimTextWithWhiteSpaces {
             let object = customDeviceAttributesText.text!
             if let data = object.data(using: .utf8) {
             do {
             if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
             CustomerIO.shared.deviceAttributes = dict
             }
             } catch {
             print(error.localizedDescription)
             }
             }
             }
             */

            $0.logLevel = findLogLevel()
            $0.autoTrackScreenViews = screenViewsSwitch.isOn
            $0.backgroundQueueSecondsDelay = !bgQueueDelayText
                .trimTextWithWhiteSpaces ? Double(bgQueueDelayText.text!)! : 30
            $0.backgroundQueueMinNumberOfTasks = !bgQueueMinTasksText
                .trimTextWithWhiteSpaces ? Int(bgQueueMinTasksText.text!)! : 10
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func logTypeDropdownTapped(_ sender: UIButton) {
        logTypeDropdown.show()
    }
}

extension ConfigureCioSdkViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // in case we plan to add validation for tracking url at later point of time
    }
}
