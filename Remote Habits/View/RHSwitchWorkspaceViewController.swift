//
//  RHSwitchWorkspaceViewController.swift
//  Remote Habits Mobile App
//
//  Created by Amandeep Kaur on 01/12/21.
//

import UIKit
import SkyFloatingLabelTextField

class RHSwitchWorkspaceViewController: RHBaseViewController, UITextFieldDelegate {

    // MARK: - --OUTLETS--
    @IBOutlet weak var apiKeyInput: SkyFloatingLabelTextField!
    @IBOutlet weak var siteIdInput: SkyFloatingLabelTextField!
    @IBOutlet weak var switchWorkspaceButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    // MARK: - VARIABLES
    var profileViewModel = DI.shared.profileViewModel
    
    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar(title: RHConstants.kCIO, hideBack: false, showLogo : false)
        addDefaultBackground()
        setUpMainView()
        setUpWorkspaceButton()
        setUpTextFields()
        setUpLabels()
    }
    
    
    // MARK: - --FUNCTIONS--
    func setUpMainView() {
        mainView.layer.cornerRadius = 13
    }
    
    func setUpWorkspaceButton() {
        switchWorkspaceButton.isEnabled = false
        switchWorkspaceButton.titleLabel?.font = RHFont.SFProTextSemiBoldMedium
        switchWorkspaceButton.setTitleColor(RHColor.TextDisabled, for: .disabled)
        switchWorkspaceButton.setTitleColor(UIColor.white, for: .normal)
        switchWorkspaceButton.layer.cornerRadius = 24
        workspaceButtonState()
    }
    
    func workspaceButtonState() {
        
        switchWorkspaceButton.backgroundColor = switchWorkspaceButton.isEnabled ? RHColor.ButtonEnabled : RHColor.ButtonDisabled
    }
    
    func setUpLabels() {
        errorLabel.isHidden = true
    }

    func setUpTextFields() {
        let textFields = [siteIdInput, apiKeyInput]
        for field in textFields {
        
            field?.errorColor = UIColor.red
            field?.tintColor = RHColor.LabelGray
            field?.lineColor = RHColor.LineGray
            field?.selectedTitleColor = RHColor.LabelGray
            field?.selectedLineColor = RHColor.SelectedLineGray
            field?.delegate = self
        }
    }
    
    func didValueChange(_ sender: Any, otherValue : String) {
        errorLabel.isHidden = true // In case, error label is visible, hide as soon as user starts typing
        
        if let floatingLabelTextField = sender as? SkyFloatingLabelTextField {
            if let text = floatingLabelTextField.text {
                if(!validateInput(with: text)) {
                    let errorSuffix = floatingLabelTextField.placeholder ?? RHConstants.kValue
                    floatingLabelTextField.errorMessage = "\(RHConstants.kInvalid) \(errorSuffix)"
                }
                else {
                    floatingLabelTextField.errorMessage = RHConstants.kEmptyValue
                }
                
                if validateInput(with: otherValue) && validateInput(with: text){
                    switchWorkspaceButton.isEnabled = true
                }else {
                    switchWorkspaceButton.isEnabled = false
                }
                
                workspaceButtonState()
            }
        }
    }
    
    func validateInput(with text : String) -> Bool{
        return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != RHConstants.kEmptyValue
    }
    
    /*
    // MARK: - --NAVIGATION--

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func routeToLogin() {
        if let navController = self.parent as? UINavigationController, let presenter = navController.presentingViewController as? UINavigationController {
            
            let main = UIStoryboard(name: RHConstants.kStoryboardMain, bundle: nil)
            let vc = main.instantiateViewController(withIdentifier: RHConstants.kLoginViewController) as! RHLoginViewController
            presenter.setViewControllers([vc], animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // MARK: - --ACTIONS--
    
    @IBAction func siteIdValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: apiKeyInput.text ?? RHConstants.kEmptyValue)
    }
    
    @IBAction func apiKeyValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: siteIdInput.text ?? RHConstants.kEmptyValue)
    }
    
    @IBAction func switchWorkspaceButtonTapped(_ sender: UIButton) {
        view.endEditing(true) // Close keyboard if it is open
        showLoadingView()
        guard let siteId = siteIdInput.text , let apikey = apiKeyInput.text else { return }
        profileViewModel.validateWorkspace(forSiteId: siteId, and: apikey) { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoadingView()
            if result {
                self.profileViewModel.logoutUser()
                self.routeToLogin()
            }
            else {
                self.errorLabel.isHidden = false
            }
        }
        
    }
}
