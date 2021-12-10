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
    
    // MARK: - --LIFECYCLE METHODS--
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar(title: RHConstants.kCIO, hideBack: false, showLogo : false)
        addDefaultBackground()
        setUpMainView()
        setUpWorkspaceButton()
        setUpTextFields()
    }
    
    
    // MARK: - --FUNCTIONS--
    func setUpMainView() {
        mainView.layer.cornerRadius = 13
    }
    
    func setUpWorkspaceButton() {
        switchWorkspaceButton.titleLabel?.font = RHFont.SFProTextSemiBoldMedium
        switchWorkspaceButton.setTitleColor(UIColor.lightGray, for: .disabled)
        switchWorkspaceButton.setTitleColor(UIColor.white, for: .normal)
        switchWorkspaceButton.isEnabled = false
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
    
    // MARK: - --ACTIONS--
    
    @IBAction func siteIdValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: apiKeyInput.text ?? RHConstants.kEmptyValue)
    }
    
    @IBAction func apiKeyValueChanged(_ sender: Any) {
        didValueChange(sender, otherValue: siteIdInput.text ?? RHConstants.kEmptyValue)
    }
}
