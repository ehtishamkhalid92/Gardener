//
//  RateVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 13.05.21.
//

import UIKit
import Firebase

class RateVC: UIViewController, UITextFieldDelegate {

    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var perPlantView: UIView!
    @IBOutlet weak var oneToFiveTextField: UITextField!
    @IBOutlet weak var sixToFifteenTextField: UITextField!
    @IBOutlet weak var sixteenPlusTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variables.
    var progressIndicator = ProgressHUD(text: "Please wait...")
    private var ref: DatabaseReference!
    
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
        if hourTextField.text!.isEmpty {
            showAlert(type: .information, Alert: "Information", details: "Please enter hourly rate", controller: self, status: false)
            hourTextField.becomeFirstResponder()
        }else if oneToFiveTextField.text!.isEmpty {
            showAlert(type: .information, Alert: "Information", details: "Please enter 1-5 Plant rate", controller: self, status: false)
            oneToFiveTextField.becomeFirstResponder()
        }else if sixToFifteenTextField.text!.isEmpty {
            showAlert(type: .information, Alert: "Information", details: "Please enter 6-15 Plant rate", controller: self, status: false)
            sixToFifteenTextField.becomeFirstResponder()
        }else if sixteenPlusTextField.text!.isEmpty {
            showAlert(type: .information, Alert: "Information", details: "Please enter 16+ Plant rate", controller: self, status: false)
            sixteenPlusTextField.becomeFirstResponder()
        }else {
            updateUser()
        }
    }
    
    //MARK:- Private Functions
    
    private func setupViews() {
        ref = Database.database().reference()
        nextBtn.addButtonShadow()
        hourView.addShadow()
        perPlantView.addShadow()
        
        hourTextField.UISetupToTextField()
        oneToFiveTextField.UISetupToTextField()
        sixToFifteenTextField.UISetupToTextField()
        sixteenPlusTextField.UISetupToTextField()
        
        hourTextField.prefixDollarToTextField()
        oneToFiveTextField.prefixDollarToTextField()
        sixToFifteenTextField.prefixDollarToTextField()
        sixteenPlusTextField.prefixDollarToTextField()
        
    }
    
    private func prefixDollarToTextField(textField: UITextField){
        let Lprefix = UILabel()
        Lprefix.font = UIFont.boldSystemFont(ofSize: 20)
        Lprefix.text = "Dollar "
        Lprefix.sizeToFit()
        let Rprefix = UILabel()
        Rprefix.font = UIFont.boldSystemFont(ofSize: 20)
        Rprefix.text = " $"
        Rprefix.sizeToFit()
        textField.rightView = Lprefix
        textField.rightViewMode = .always
        textField.leftView = Rprefix
        textField.leftViewMode = .always // or .always
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    private func updateUser(){
        self.view.addSubview(progressIndicator)
        var user = SessionManager.instance.userData
        
        user.rates = [hourTextField.text!,oneToFiveTextField.text!,sixToFifteenTextField.text!,sixteenPlusTextField.text!]
        user.isProfileCompleted = true
        let dict:[String:Any] = [
            "rates":user.rates,
            "isProfileCompleted" : true
        ]
        
        self.ref.child("USER").child(user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: SessionManager.instance.user)
                }
                SessionManager.instance.loginData()
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
}
