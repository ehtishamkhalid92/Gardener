//
//  RegistrationStepOneVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 11.05.21.
//

import UIKit
import Firebase

class RegistrationStepOneVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK:- Variables.
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        moveToNextView()
    }
    
    
    //MARK:- Private Functions
    private func moveToNextView() {
        if firstNameTextField.text!.isEmpty {
            firstNameTextField.becomeFirstResponder()
        }else if lastNameTextField.text!.isEmpty {
            lastNameTextField.becomeFirstResponder()
        }else {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "EmailViewController") as! EmailViewController
            var user = UserModel()
            user.firstName = firstNameTextField.text!
            user.lastName = lastNameTextField.text!
            vc.user = user
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        ref = Database.database().reference()
//        self.headingLbl.text = "Basic\nInformation"
        self.firstNameTextField.UISetupToTextField()
        self.lastNameTextField.UISetupToTextField()
        self.nextBtn.addButtonShadow()
    }
  
}

extension RegistrationStepOneVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moveToNextView()
        return true
    }
}
