//
//  ForgotPasswordVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase
class ForgotPasswordVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.addButtonShadow()
        emailTextField.UISetupToTextField()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendRequestBtnTapped(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil {
                showAlert(type: .success, Alert: "Request Send", details: "An email is send to your register email address", controller: self, status: false)
                self.emailTextField.text = ""
            }else {
                showAlert(type: .error, Alert: "Error", details: "\(error?.localizedDescription ?? "")", controller: self, status: false)
            }
        }
    }

}
