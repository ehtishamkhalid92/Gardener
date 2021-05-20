//
//  LoginVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var wateringImage: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var appIconLbl: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    //MARK:- Variables
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        if emailTextField.text!.isEmpty{
            showAlert(title: "Empty Text Field!", message: "Please enter your login email address.", controller: self)
        }else if passwordTextField.text!.isEmpty{
            showAlert(title: "Empty Text Field!", message: "Please enter your login password.", controller: self)
        }else {
            applyLogin()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private Function
    private func setupViews(){
        ref = Database.database().reference()
        emailTextField.UISetupToTextField()
        passwordTextField.UISetupToTextField()
        signInBtn.addButtonShadow()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func applyLogin(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
                showAlert(title: "Operation Not Allowed!", message: "Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console", controller: self)
            case .userDisabled:
                showAlert(title: "User Disabled!", message: "The user account has been disabled by an administrator", controller: self)
            case .wrongPassword:
                showAlert(title: "Wrong Password!", message: "The password is invalid or the user does not have a password.", controller: self)
            case .invalidEmail:
                showAlert(title: "Invalid Email!", message: "Indicates the email address is malformed.", controller: self)
            case .userNotFound:
                showAlert(title: "User Not Found!", message: "No user found regarding this email address.", controller: self)
            default:
                showAlert(title: "Error!", message: "\(error.localizedDescription)", controller: self)
            }
          } else {
            let userInfo = Auth.auth().currentUser
            let userId = userInfo?.uid
            self.observeUserData(userId: userId ?? "")
          }
        }
    }
    private func observeUserData(userId:String) {
        self.view.addSubview(self.progressIndicator)
        self.ref.child("USER").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.progressIndicator.removeFromSuperview()
            // Get user value
            let value = snapshot.value as? NSDictionary
            var user = UserModel()
            user.address = value?["address"] as? String ?? ""
            user.city = value?["city"] as? String ?? ""
            user.country = value?["country"] as? String ?? ""
            user.countryCode = value?["countryCode"] as? String ?? ""
            user.date = value?["date"] as? String ?? ""
            user.email = value?["email"] as? String ?? ""
            user.firstName = value?["firstName"] as? String ?? ""
            user.filePath = value?["filePath"] as? String ?? ""
            user.fileName = value?["imageName"] as? String ?? ""
            user.isPhoneVerified = value?["isPhoneVerified"] as? Bool ?? false
            user.isUserVerified = value?["isUserVerified"] as? Bool ?? false
            user.isProfileCompleted = value?["isProfileCompleted"] as? Bool ?? false
            user.lastName = value?["lastName"] as? String ?? ""
            user.phoneNumber = value?["phoneNumber"] as? String ?? ""
            user.postalCode = value?["postalCode"] as? String ?? ""
            user.role = value?["role"] as? String ?? ""
            user.state = value?["state"] as? String ?? ""
            user.userId = value?["userID"] as? String ?? ""
            user.notification = false
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SessionManager.instance.user)
            }
            SessionManager.instance.loginData()
            }) { (error) in
              print(error.localizedDescription)
            showAlert(title: "Login", message: "Error: \(error.localizedDescription)", controller: self)
          }
    }
}
extension LoginVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            applyLogin()
        }
        return true
    }
}
