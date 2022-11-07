import CioTracking
import SkyFloatingLabelTextField
import UIKit

class SwitchWorkspaceViewController: BaseViewController, UITextFieldDelegate {
    static func newInstance() -> SwitchWorkspaceViewController {
        UIStoryboard.getViewController(identifier: Constants.kSwitchWorkspaceViewController)
    }

    // MARK: - --OUTLETS--

    @IBOutlet var apiKeyInput: SkyFloatingLabelTextField!
    @IBOutlet var siteIdInput: SkyFloatingLabelTextField!
    @IBOutlet var switchWorkspaceButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var errorLabel: UILabel!

    // MARK: - VARIABLES

    var profileViewModel = DI.shared.profileViewModel
    var userManager = DI.shared.userManager
    var workspaceData: WorkspaceData?
    var switchWorkspaceRouter: SwitchWorkspaceRouting?

    // MARK: - --LIFECYCLE METHODS--

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sending custom attributes to the workspace
        CustomerIO.shared.deviceAttributes = [
            "name": userManager.userName ?? "Guest",
            "currentScreen": "SwitchWorkspace",
            "isAuthorizedUser": userManager.isLoggedIn
        ]
        // Do any additional setup after loading the view.
        configureNavigationBar(title: Constants.kCIO, hideBack: false, showLogo: false)
        configureSwitchWorkspaceRouter()
        addDefaultBackground()
        setUpMainView()
        setUpWorkspaceButton()
        setUpTextFields()
        setUpLabels()
    }

    // MARK: - --FUNCTIONS--

    func setUpMainView() {
        mainView.setCornerRadius(.radius13)
        mainView.backgroundColor = Color.PrimaryBackground
    }

    func configureSwitchWorkspaceRouter() {
        let router = SwitchWorkspaceRouter()
        switchWorkspaceRouter = router
        router.switchWorkspaceViewController = self
    }

    func setUpWorkspaceButton() {
        switchWorkspaceButton.isEnabled = false
        switchWorkspaceButton.titleLabel?.font = Font.SFProTextSemiBoldMedium
        switchWorkspaceButton.setTitleColor(Color.TextDisabled, for: .disabled)
        switchWorkspaceButton.setTitleColor(UIColor.white, for: .normal)
        switchWorkspaceButton.setCornerRadius(.radius24)
        workspaceButtonState()
    }

    func workspaceButtonState() {
        switchWorkspaceButton.backgroundColor = switchWorkspaceButton.isEnabled ? Color.ButtonEnabled : Color
            .ButtonDisabled
    }

    func setUpLabels() {
        errorLabel.isHidden = true
    }

    func setUpTextFields() {
        let textFields = [siteIdInput, apiKeyInput]
        for field in textFields {
            field?.errorColor = UIColor.red
            field?.tintColor = Color.LabelGray
            field?.lineColor = Color.LineGray
            field?.selectedTitleColor = Color.LabelLightGray
            field?.selectedLineColor = Color.SelectedLineGray
            field?.placeholderColor = Color.LabelLightGray
            field?.textColor = Color.LabelBlack
            field?.delegate = self

            switch field {
            case siteIdInput:
                field?.text = workspaceData?.siteId ?? ""
            case apiKeyInput:
                field?.text = workspaceData?.apiKey ?? ""
            default:
                break
            }
        }
        validateInputsAndHandleWorkspaceButton(with: siteIdInput.text ?? "", andApiKey: apiKeyInput.text ?? "")
    }

    func didValueChange(_ sender: Any, otherValue: String) {
        errorLabel.isHidden = true // In case, error label is visible, hide as soon as user starts typing

        if let floatingLabelTextField = sender as? SkyFloatingLabelTextField {
            if let text = floatingLabelTextField.text {
                if !validateInput(with: text) {
                    let errorSuffix = floatingLabelTextField.placeholder ?? Constants.kValue
                    floatingLabelTextField.errorMessage = "\(Constants.kInvalid) \(errorSuffix)"
                } else {
                    floatingLabelTextField.errorMessage = Constants.kEmptyValue
                }
                validateInputsAndHandleWorkspaceButton(with: text, andApiKey: otherValue)
            }
        }
    }

    func validateInputsAndHandleWorkspaceButton(with textValue: String, andApiKey otherTextValue: String) {
        if validateInput(with: textValue), validateInput(with: otherTextValue) {
            switchWorkspaceButton.isEnabled = true
        } else {
            switchWorkspaceButton.isEnabled = false
        }
        workspaceButtonState()
    }

    func validateInput(with text: String) -> Bool {
        text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != Constants.kEmptyValue
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    /*
     // MARK: - --NAVIGATION--

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    // MARK: - --ACTIONS--

    @IBAction func siteIdValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: apiKeyInput.text ?? Constants.kEmptyValue)
    }

    @IBAction func apiKeyValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: siteIdInput.text ?? Constants.kEmptyValue)
    }

    @IBAction func switchWorkspaceButtonTapped(_ sender: UIButton) {
        view.endEditing(true) // Close keyboard if it is open
        showLoadingView()
        guard let siteId = siteIdInput.text, let apikey = apiKeyInput.text else { return }
        profileViewModel.validateWorkspace(forSiteId: siteId, and: apikey) { [weak self] result in
            guard let self = self else { return }

            self.hideLoadingView()
            if result {
                self.profileViewModel.logoutUser()
                self.updateWorkspaceInfo(with: siteId, andApiKey: apikey)
                self.switchWorkspaceRouter?.routeToLogin()
            } else {
                self.errorLabel.isHidden = false
            }
        }
    }

    private func updateWorkspaceInfo(with siteId: String, andApiKey apiKey: String) {
        userManager.workspaceID = siteId
        userManager.apiKey = apiKey

        appDelegate?.initializeCustomerIOSdk()
    }
}
