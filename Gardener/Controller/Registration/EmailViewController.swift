//
//  EmailViewController.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 20.05.21.
//

import UIKit

class EmailViewController: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK:- Variables.
    var user = UserModel()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        moveToNextView()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private Function.
    private func setupViews(){
        nextBtn.addButtonShadow()
        emailTextField.UISetupToTextField()
        emailTextField.delegate = self
    }
    
    private func moveToNextView(){
        if emailTextField.text!.isEmpty{
            showAlert(title: "Empty Text Field!", message: "Enter your Email Address to continue.", controller: self)
        }else if !isValidEmail(email: emailTextField.text!){
            showAlert(title: "Wrong email format!", message: "Email that you have entered have bad format. Please enter a valid email address. Thank you!", controller: self)
        }else {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "PasswordViewController") as! PasswordViewController
            self.user.email = emailTextField.text!
            vc.user = user
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
extension EmailViewController: UITextFieldDelegate{
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextView()
        return true
    }
}
