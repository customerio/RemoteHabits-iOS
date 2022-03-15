import CioTracking
import SkyFloatingLabelTextField
import UIKit

class LoginViewController: BaseViewController {
    // MARK: - --OUTLETS--

    static func newInstance() -> LoginViewController {
        UIStoryboard.getViewController(identifier: Constants.kLoginViewController)
    }

    @IBOutlet var userNameInput: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var emailInput: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var guestButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var errorMessageLabel: UILabel!

    // MARK: - --VARIABLES--

    var floatingButton: UIButton!
    var userManager = DI.shared.userManager
    var textFields: [SkyFloatingLabelTextFieldWithIcon] = []
    var profileViewModel = DI.shared.profileViewModel
    var loginRouter: LoginRouting?
    var loggedInState: ProfileViewModel.LoggedInProfileState {
        profileViewModel.loggedInProfileState
    }

    // MARK: - --LIFECYCLE METHODS--

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        floatingSettingButton()
        configureLoginRouter()
        addNotifierObserver()
        addLoginBackground()
        textFields = [userNameInput, emailInput]
        setUpTextFields()
        setupButtons()
        setUpMainView()
        actOnError(toShow: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - --FUNCTIONS--

    func addNotifierObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSwitchWorkspace(notification:)),
                                               name: Notification
                                                   .Name(Constants.kSwitchWorkspacePreLoginIdentifier),
                                               object: nil)
    }

    @objc func handleSwitchWorkspace(notification: Notification) {
        guard let siteId = notification.userInfo?["site_id"] as? String,
              let apiKey = notification.userInfo?["api_key"] as? String
        else {
            loginRouter?.routeToWorkspace(withData: nil)
            return
        }
        let workspaceData = WorkspaceData(apiKey: apiKey, siteId: siteId)
        loginRouter?.routeToWorkspace(withData: workspaceData)
    }

    func configureLoginRouter() {
        let router = LoginRouter()
        loginRouter = router
        router.loginViewController = self
    }

    func setupButtons() {
        // Buttons
        loginButton.isEnabled = false
        loginButton.titleLabel?.font = Font.SFProTextSemiBoldMedium
        loginButton.setTitleColor(Color.TextDisabled, for: .disabled)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setCornerRadius(.radius24)
        loginButtonState()
    }

    func loginButtonState() {
        loginButton.backgroundColor = loginButton.isEnabled ? Color.ButtonEnabled : Color.ButtonDisabled
    }

    func setUpTextFields() {
        for field in textFields {
            switch field {
            case userNameInput:
                field.iconText = Icons.user.rawValue

            case emailInput:
                field.iconText = Icons.email.rawValue
            default:
                break
            }

            field.placeholderColor = Color.LabelGray
            field.textColor = UIColor.black
            field.iconFont = Font.AwesomeFontLarge
            field.tintColor = Color.LabelGray
            field.lineColor = Color.LineGray
            field.selectedTitleColor = Color.LabelGray
            field.selectedLineColor = Color.SelectedLineGray
            field.delegate = self
        }
    }

    func setUpMainView() {
        mainView.setCornerRadius(.radius13)
    }

    func validateName(_ nameText: UITextField) -> Bool {
        !nameText.trimTextWithWhiteSpaces
    }

    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func actOnError(toShow: Bool) {
        if toShow {
            errorMessageLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.errorMessageLabel.isHidden = true
            }
        } else {
            errorMessageLabel.isHidden = true
        }
    }

    func routeToDashboard() {
        userNameInput.text = Constants.kEmptyValue
        emailInput.text = Constants.kEmptyValue
        loginButton.isEnabled = false
        loginButtonState()
        loginRouter?.routeToDashboard()
    }

    func populateInitialHabitData() {
        if habitsDataManager.deleteHabits() {
            let data = RemoteHabitsData().getHabitsData()
            habitsDataManager.createHabit(forData: data)
        }
    }

    // MARK: - --ACTIONS--

    @IBAction func emailDidChange(_ sender: Any) {
        if let floatingLabelTextField = sender as? SkyFloatingLabelTextFieldWithIcon {
            if let text = floatingLabelTextField.text {
                if !validateEmail(text) {
                    floatingLabelTextField.errorMessage = Constants.errorMessageLoginScreenEmailNotValid
                } else {
                    floatingLabelTextField.errorMessage = Constants.kEmptyValue
                    floatingLabelTextField.text = floatingLabelTextField.text
                }
                if validateName(userNameInput), validateEmail(text) {
                    loginButton.isEnabled = true
                } else {
                    loginButton.isEnabled = false
                }
            }
        }
        loginButtonState()
    }

    @IBAction func nameDidChange(_ sender: Any) {
        if let field = sender as? UITextField {
            if validateName(field), validateEmail(emailInput.text ?? Constants.kEmptyValue) {
                loginButton.isEnabled = true
            } else {
                loginButton.isEnabled = false
            }
        }
        loginButtonState()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let eId = emailInput.text, let username = userNameInput.text else {
            return
        }
        validateCredentials(email: eId, pwd: Constants.kDefaultPassword, firstName: username, isGenRandom: false)
    }

    @IBAction func guestButtonTapped(_ sender: UIButton) {
        validateCredentials(email: Constants.kRandomEId, pwd: Constants.kDefaultPassword,
                            firstName: Constants.kRandomUsername, isGenRandom: true)
    }

    func validateCredentials(email: String, pwd: String, firstName: String, isGenRandom: Bool) {
        showLoadingView()
        view.endEditing(true)

        profileViewModel
            .loginUser(email: email, password: pwd, firstName: firstName, generatedRandom: isGenRandom) { result in
                self.populateInitialHabitData()
                self.hideLoadingView()
                if result {
                    self.routeToDashboard()
                } else {
                    self.actOnError(toShow: true)
                }
            }
    }

    @objc func floatingButtonTapped() {
        loginRouter?.routeToConfigureCioSdk()
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailInput, textField.trimTextWithWhiteSpaces {
            if let field = textField as? SkyFloatingLabelTextFieldWithIcon {
                field.errorMessage = Constants.kEmptyValue
            }
        }
    }
}

// MARK: - Floating Button

extension LoginViewController {
    func floatingSettingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.customiseFloating()
        floatingButton.addTarget(self, action: #selector(LoginViewController.floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)
    }
}
