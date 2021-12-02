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

    // MARK: - --VARIABLES--
    var textFields: [SkyFloatingLabelTextFieldWithIcon] = []
    
    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addLoginBackground()
        textFields = [userNameInput, emailInput]
        setUpTextFields()
        setupButtons()
        setUpMainView()
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
        loginButton.isEnabled = false // TODO : Disable when doing push
        loginButton.titleLabel?.font = RHFont.SFProTextSemiBoldMedium
        loginButton.setTitleColor(UIColor.gray, for: .disabled)
        loginButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setUpTextFields() {
        for field in textFields {
            
            switch(field) {
            case userNameInput :
                field.iconText = "\u{f007}"
            case emailInput:
                field.iconText = "\u{f0e0}"
                field.errorColor = UIColor.red
            default:
                break
            }
            
            field.iconFont = RHFont.AwesomeFontLarge
            field.tintColor = RHColor.LabelGray
            field.lineColor = RHColor.LineGray
            field.selectedTitleColor = RHColor.LabelGray
            field.selectedLineColor = RHColor.SelectedLineGray
            field.delegate = self
        }
    }
    
    func setUpMainView() {
        mainView.layer.cornerRadius = 13
    }
    
    func validateName(_ name : String) -> Bool {
        return name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != RHConstants.kEmptyValue
    }
    
    func validateEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    // MARK: - --ACTIONS--
    @IBAction func emailDidChange(_ sender: Any) {
        
        if let floatingLabelTextField = sender as? SkyFloatingLabelTextFieldWithIcon {
            if let text = floatingLabelTextField.text {
                if(!validateEmail(text)) {
                    floatingLabelTextField.errorMessage = RHConstants.kInvalidEmail
                }
                else {
                    floatingLabelTextField.errorMessage = RHConstants.kEmptyValue
                }
                
                if validateName(userNameInput.text ?? RHConstants.kEmptyValue) && validateEmail(text){
                    loginButton.isEnabled = true
                }else {
                    loginButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func nameDidChange(_ sender: Any) {
        
        if let field = sender as? UITextField {
            
            if let text = field.text {
                if validateName(text) && validateEmail(emailInput.text ?? RHConstants.kEmptyValue){
                    loginButton.isEnabled = true
                }else {
                    loginButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if let viewController  = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil).instantiateViewController(withIdentifier: RHConstants.kDashboardViewController) as? RHDashboardViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func guestButtonTapped(_ sender: UIButton) {
        if let viewController  = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil).instantiateViewController(withIdentifier: RHConstants.kDashboardViewController) as? RHDashboardViewController {
            viewController.isLoggedIn = false
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension RHLoginViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailInput && textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == RHConstants.kEmptyValue {
            if let field = textField as? SkyFloatingLabelTextFieldWithIcon {
                field.errorMessage = RHConstants.kEmptyValue
            }
        }
    }
}
