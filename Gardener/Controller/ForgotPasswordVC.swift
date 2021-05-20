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
                let alert = UIAlertController(title: "Reset Password Request Send!", message: "An email is send to your register email address. Please click the link in the email to reset your password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }else {
                showAlert(title: "Reset Password", message: "\(error?.localizedDescription ?? "")", controller: self)
            }
        }
    }

}
