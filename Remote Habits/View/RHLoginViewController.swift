//
//  RHLoginViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 25/11/21.
//

import UIKit
import SkyFloatingLabelTextField


class RHLoginViewController: RHBaseViewController {

    // MARK: - --OUTLETS--
    @IBOutlet weak var userNameInput: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailInput: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - --VARIABLES--
    var userManager = DI.shared.userManager
//    let habitsDataManager = HabitDataManager()
    var textFields: [SkyFloatingLabelTextFieldWithIcon] = []
    var profileViewModel = DI.shared.profileViewModel
    var loggedInState: ProfileViewModel.LoggedInProfileState {
        profileViewModel.loggedInProfileState
    }
    
    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

    // MARK: - --FUNCTIONS--
    func setupButtons() {
        
        // Buttons
        loginButton.isEnabled = false
        loginButton.titleLabel?.font = RHFont.SFProTextSemiBoldMedium
        loginButton.setTitleColor(RHColor.TextDisabled, for: .disabled)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setCornerRadius(.radius24)
        loginButtonState()
    }
    
    func loginButtonState() {
        
        loginButton.backgroundColor = loginButton.isEnabled ? RHColor.ButtonEnabled : RHColor.ButtonDisabled
    }

    func setUpTextFields() {
        for field in textFields {
            
            switch(field) {
            case userNameInput :
                field.iconText = "\u{f007}"
            case emailInput:
                field.iconText = "\u{f0e0}"
            default:
                break
            }
            
            field.placeholderColor = RHColor.LabelGray
            field.textColor = UIColor.black
            field.iconFont = RHFont.AwesomeFontLarge
            field.tintColor = RHColor.LabelGray
            field.lineColor = RHColor.LineGray
            field.selectedTitleColor = RHColor.LabelGray
            field.selectedLineColor = RHColor.SelectedLineGray
            field.delegate = self
        }
    }
    
    func setUpMainView() {
        mainView.setCornerRadius(.radius13)
    }
    
    func validateName(_ nameText : UITextField) -> Bool {
        return !nameText.trimTextWithWhiteSpaces
    }
    
    func validateEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func actOnError(toShow: Bool) {
        
        if toShow {
            errorMessageLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.errorMessageLabel.isHidden = true
            }
        }else {
            errorMessageLabel.isHidden = true
        }
    }
    func routeToDashboard(isGuestLogin : Bool = true) {
        userNameInput.text = RHConstants.kEmptyValue
        emailInput.text = RHConstants.kEmptyValue
        loginButton.isEnabled = false
        loginButtonState()
        
        if let viewController  = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil).instantiateViewController(withIdentifier: RHConstants.kDashboardViewController) as? RHDashboardViewController {
            viewController.isSourceLogin = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func fillHabitData() {
        if habitsDataManager.deleteHabits() {
            let data = RemoteHabitsData().getHabitsData()
            habitsDataManager.createHabit(forData: data)
        }
    }
    
    // MARK: - --ACTIONS--
    @IBAction func emailDidChange(_ sender: Any) {
        
        if let floatingLabelTextField = sender as? SkyFloatingLabelTextFieldWithIcon {
            if let text = floatingLabelTextField.text {
                if(!validateEmail(text)) {
                    floatingLabelTextField.errorMessage = RHConstants.errorMessageLoginScreenEmailNotValid
                }
                else {
                    floatingLabelTextField.errorMessage = RHConstants.kEmptyValue
                    floatingLabelTextField.text = floatingLabelTextField.text
                }
                if validateName(userNameInput) && validateEmail(text){
                    loginButton.isEnabled = true
                }else {
                    loginButton.isEnabled = false
                }
            }
        }
        loginButtonState()
    }
    
    @IBAction func nameDidChange(_ sender: Any) {
        
        if let field = sender as? UITextField {
            
            if validateName(field) && validateEmail(emailInput.text ?? RHConstants.kEmptyValue){
                loginButton.isEnabled = true
            }else {
                loginButton.isEnabled = false
            }
        }
        loginButtonState()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let eId = emailInput.text, let username = userNameInput.text else {
            return
        }
        validateCredentials(email: eId, pwd: RHConstants.kDefaultPassword, firstName: username, isGenRandom: false)
    }
    
    @IBAction func guestButtonTapped(_ sender: UIButton) {
        validateCredentials(email: RHConstants.kRandomEId, pwd: RHConstants.kDefaultPassword, firstName: RHConstants.kRandomUsername, isGenRandom: true)
    }
    
    func validateCredentials(email : String, pwd : String, firstName : String, isGenRandom : Bool) {
        showLoadingView()
        view.endEditing(true)
        profileViewModel.loginUser(email: email, password: pwd, firstName: firstName, generatedRandom: isGenRandom){ result in
            self.fillHabitData()

            self.hideLoadingView()
            if result {
                self.routeToDashboard(isGuestLogin: isGenRandom)
            }
            else {
                self.actOnError(toShow: true)
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension RHLoginViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailInput && textField.trimTextWithWhiteSpaces {
            if let field = textField as? SkyFloatingLabelTextFieldWithIcon {
                field.errorMessage = RHConstants.kEmptyValue
            }
        }
    }
}
