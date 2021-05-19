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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var countryCodeTextField: UITextField!
    
    //MARK:- Variables.
    private let pickerView = UIPickerView()
    private lazy var arrOfCountriesWithTheirValues = [CountryCodeModel]()
    private var selectedCountryCode :String?
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
        textFieldValidation()
    }
    
    
    //MARK:- Private Functions
    private func textFieldValidation() {
        if firstNameTextField.text!.isEmpty {
            firstNameTextField.becomeFirstResponder()
        }else if lastNameTextField.text!.isEmpty {
            lastNameTextField.becomeFirstResponder()
        }else if emailTextField.text!.isEmpty{
            emailTextField.becomeFirstResponder()
        }else if !isValidEmail(email: emailTextField.text!){
            emailTextField.becomeFirstResponder()
            showAlert(type: .information, Alert: "Wrong email format", details: "Email that you have entered have bad format. Please enter a valid email address. Thank you!", controller: self, status: false)
        }else if countryCodeTextField.text!.isEmpty{
            countryCodeTextField.becomeFirstResponder()
        }else if phoneNumTextField.text!.isEmpty{
            phoneNumTextField.becomeFirstResponder()
        }else if passwordTextField.text!.isEmpty{
            passwordTextField.becomeFirstResponder()
        }else if !isValidatePassword(passwordTextField.text!){
            passwordTextField.becomeFirstResponder()
            showAlert(type: .Warning, Alert: "Week Password", details: "Your password must contains 8 characters, At least one digit and one letter and no white space. Thank you!", controller: self, status: false)
        }else if passwordTextField.text! != confirmPasswordTextField.text {
            confirmPasswordTextField.becomeFirstResponder()
            showAlert(type: .Warning, Alert: "Password Does not Match", details: "Your confirm password does not match with the password please verify your password. Thank you!", controller: self, status: false)
        }else {
            CreateUser()
        }
    }
    
    private func setupViews() {
        ref = Database.database().reference()
        self.headingLbl.text = "Basic\nInformation"
        self.firstNameTextField.UISetupToTextField()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.UISetupToTextField()
        self.lastNameTextField.delegate = self
        self.emailTextField.UISetupToTextField()
        self.emailTextField.delegate = self
        self.phoneNumTextField.UISetupToTextField()
        self.phoneNumTextField.delegate = self
        self.passwordTextField.UISetupToTextField()
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.UISetupToTextField()
        self.confirmPasswordTextField.delegate = self
        self.countryCodeTextField.roundAndBackgroundColorField()
        self.countryCodeTextField.delegate = self
        self.nextBtn.addButtonShadow()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        countryCodeTextField.inputView = pickerView
        
        for (key, value) in dialingCodes {
            print(value)
            if let country = countryName(countryCode: key) {
                let name = country
                let emojiFlag = flag(country: key)
                let flag = emojiFlag
                let code = value
                let countryCode = key
                let obj = CountryCodeModel(flag: flag, code: code, countryName: name, countryCode: countryCode)
                arrOfCountriesWithTheirValues.append(obj)
            }
        }
        
        let sortedArray = arrOfCountriesWithTheirValues.sorted(by: { $0.countryName < $1.countryName })
        self.arrOfCountriesWithTheirValues.removeAll()
        self.arrOfCountriesWithTheirValues = sortedArray
        
    }
    
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    private func flag(country: String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    private func CreateUser(){
        self.view.addSubview(progressIndicator)
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    showAlert(type: .information, Alert: "Information", details: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section", controller: self, status: false)
                    self.progressIndicator.removeFromSuperview()
                case .emailAlreadyInUse:
                    showAlert(type: .information, Alert: "Information", details: "The email address is already in use by another account", controller: self, status: false)
                    self.progressIndicator.removeFromSuperview()
                case .invalidEmail:
                    showAlert(type: .information, Alert: "Information", details: "The email address is badly formatted", controller: self, status: false)
                    self.progressIndicator.removeFromSuperview()
                case .weakPassword:
                    showAlert(type: .information, Alert: "Information", details: "The password must be 6 characters long or more", controller: self, status: false)
                    self.progressIndicator.removeFromSuperview()
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                let newUserInfo = Auth.auth().currentUser
                let userId = newUserInfo?.uid
                self.addUserChildData(userId: userId ?? "")
            }
        }
    }
    
    private func addUserChildData(userId:String){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = df.string(from: Date())
//        let userId = self.ref?.childByAutoId().key ?? ""
        var user = UserModel()
        user.firstName = firstNameTextField.text!
        user.lastName = lastNameTextField.text!
        user.email = emailTextField.text!
        user.countryCode = countryCodeTextField.text!
        user.phoneNumber = phoneNumTextField.text!
        user.date = date
        user.userId = userId
        user.isPhoneVerified = false
        
        let dict :[String:Any] = [
            "userID":user.userId,
            "firstName":user.firstName,
            "lastName":user.lastName,
            "email":user.email,
            "countryCode":user.countryCode,
            "phoneNumber":user.phoneNumber,
            "date":user.date,
            "isPhoneVerified":user.isPhoneVerified,
        ]
        self.ref.child("USER").child(userId).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "RegistrationStepThreeVC") as! RegistrationStepThreeVC
                vc.user = user
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }

}
extension RegistrationStepOneVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfCountriesWithTheirValues.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let instance = arrOfCountriesWithTheirValues[row]
        let title = "\(instance.flag)  \(instance.countryName)  +\(instance.code)"
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let instance = arrOfCountriesWithTheirValues[row]
        let title = "\(instance.countryCode) +\(instance.code)"
        countryCodeTextField.text = title
        self.selectedCountryCode = instance.code
    }
}
extension RegistrationStepOneVC: UITextFieldDelegate{
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
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
        textField.resignFirstResponder()
        return true
    }
}
