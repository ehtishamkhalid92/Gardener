//
//  RegistrationStepTwoVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit

class RegistrationStepTwoVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var phoneNumLbl: UILabel!
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    @IBOutlet weak var fiveTextField: UITextField!
    @IBOutlet weak var sixTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    //MARK:- Variables
    var phoneNum = String()
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "RegistrationStepThreeVC") as! RegistrationStepThreeVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Private function
    private func setupViews() {
        nextBtn.addButtonShadow()
        oneTextField.roundAndBackgroundColorField()
        twoTextField.roundAndBackgroundColorField()
        threeTextField.roundAndBackgroundColorField()
        fourTextField.roundAndBackgroundColorField()
        fiveTextField.roundAndBackgroundColorField()
        sixTextField.roundAndBackgroundColorField()
        oneTextField.becomeFirstResponder()
        oneTextField.delegate = self
        twoTextField.delegate = self
        threeTextField.delegate = self
        fourTextField.delegate = self
        fiveTextField.delegate = self
        sixTextField.delegate = self
        oneTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        twoTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        threeTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fiveTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        sixTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        phoneNumLbl.text = "Sent to +\(phoneNum)"
    }
    
}
extension RegistrationStepTwoVC: UITextFieldDelegate{
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField{
            case oneTextField:
                twoTextField.becomeFirstResponder()
            case twoTextField:
                threeTextField.becomeFirstResponder()
            case threeTextField:
                fourTextField.becomeFirstResponder()
            case fourTextField:
                fiveTextField.becomeFirstResponder()
            case fiveTextField:
                sixTextField.becomeFirstResponder()
            case sixTextField:
                sixTextField.resignFirstResponder()
            default:
                self.view.endEditing(true)
                break
            }
        }else{
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
