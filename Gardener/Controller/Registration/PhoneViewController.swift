//
//  PhoneViewController.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 20.05.21.
//

import UIKit

class PhoneViewController: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variables.
    private let pickerView = UIPickerView()
    private lazy var arrOfCountriesWithTheirValues = [CountryCodeModel]()
    private var selectedCountryCode :String?
    var user = UserModel()
    
    //MARK:- View Life cycle.
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
        phoneTextField.UISetupToTextField()
        countryCodeTextField.UISetupToTextField()
        nextBtn.addButtonShadow()
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
    
    private func moveToNextView() {
        if countryCodeTextField.text!.isEmpty{
            countryCodeTextField.becomeFirstResponder()
        }else if phoneTextField.text!.isEmpty{
            phoneTextField.becomeFirstResponder()
        }else {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "RegistrationStepThreeVC") as! RegistrationStepThreeVC
            self.user.countryCode = countryCodeTextField.text!
            self.user.phoneNumber = phoneTextField.text!
            vc.user = user
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
extension PhoneViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
