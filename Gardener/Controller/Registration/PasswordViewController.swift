//
//  PasswordViewController.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 20.05.21.
//

import UIKit

class PasswordViewController: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variables
    var user = UserModel()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        moveToNextView()
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        passwordTextField.UISetupToTextField()
        confirmPasswordTextField.UISetupToTextField()
        nextBtn.addButtonShadow()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func moveToNextView(){
        if passwordTextField.text!.isEmpty {
            showAlert(title: "Empty Text Field!", message: "Please enter your password to continue.", controller: self)
        }else if !isValidatePassword(passwordTextField.text!){
            passwordTextField.becomeFirstResponder()
            showAlert(title: "Week Password!", message: "Your password must contains 8 characters, At least one digit and one letter and no white space. Thank you!", controller: self)
        }else if passwordTextField.text! != confirmPasswordTextField.text {
            confirmPasswordTextField.becomeFirstResponder()
            showAlert(title: "Password Does not Match!", message: "Your confirm password does not match with the password please verify your password. Thank you!", controller: self)
        }else {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "PhoneViewController") as! PhoneViewController
            self.user.password = passwordTextField.text!
            vc.user = user
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}
extension PasswordViewController: UITextFieldDelegate{
    func isValidatePassword(_ password: String) -> Bool {
        //At least 8 characters
        if password.count < 8 {
            return false
        }
        //At least one digit
        if password.range(of: #"\d+"#, options: .regularExpression) == nil {
            return false
        }
        //At least one letter
        if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
            return false
        }
        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            return false
        }

        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }else if textField == confirmPasswordTextField{
            moveToNextView()
        }
        return true
    }
}
