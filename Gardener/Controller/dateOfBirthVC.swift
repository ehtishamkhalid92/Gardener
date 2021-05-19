//
//  dateOfBirthVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 13.05.21.
//

import UIKit
import Firebase
import SDWebImage

class dateOfBirthVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateOneTextField: UITextField!
    @IBOutlet weak var dateTwoTextField: UITextField!
    @IBOutlet weak var monthOneTextField: UITextField!
    @IBOutlet weak var monthTwoTextField: UITextField!
    @IBOutlet weak var yearOneTextField: UITextField!
    @IBOutlet weak var yearTwoTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    
    //MARK:- Variables.
    var progressIndicator = ProgressHUD(text: "Please wait...")
    private var ref: DatabaseReference!
    var postDate : Date?
    
    
    // Age of 18.
    let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    // Age of 100.
    let MAXIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    
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
        if postDate == nil {
            showAlert(type: .information, Alert: "Information", details: "Please select your date of birth!", controller: self, status: false)
        }else {
            updateUser()
        }
    }
    
    @objc func nextBtnTapped(sender: UIButton){
        
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        postDate = sender.date
        let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: sender.date)
        let splitString = strDate.components(separatedBy: "-")
        let dayArray = Array(splitString[0])
        self.dateOneTextField.text = "\(dayArray[0])"
        self.dateTwoTextField.text = "\(dayArray[1])"
        let monthArray = Array(splitString[1])
        self.monthOneTextField.text = "\(monthArray[0])"
        self.monthTwoTextField.text = "\(monthArray[1])"
        let yearArray = Array(splitString[2])
        self.yearOneTextField.text = "\(yearArray[2])"
        self.yearTwoTextField.text = "\(yearArray[3])"
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        if #available(iOS 14.0, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        nextBtn.addButtonShadow()
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
        dateOneTextField.roundAndBackgroundColorField()
        dateTwoTextField.roundAndBackgroundColorField()
        monthOneTextField.roundAndBackgroundColorField()
        monthTwoTextField.roundAndBackgroundColorField()
        yearOneTextField.roundAndBackgroundColorField()
        yearTwoTextField.roundAndBackgroundColorField()
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        profileImage.layer.masksToBounds = true
        datePickerView.maximumDate = MINIMUM_AGE
        datePickerView.minimumDate = MAXIMUM_AGE
        
        
        let user = SessionManager.instance.userData
        profileImage.sd_setImage(with: URL(string: user.filePath), placeholderImage: UIImage(named: "profile"))
        nameLbl.text = user.firstName + " " + user.lastName
        addressLbl.text = "\(user.city), \(user.state) \(user.country)"
    }
    
    private func updateUser(){
        self.view.addSubview(progressIndicator)
        var user = SessionManager.instance.userData
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = df.string(from: postDate!)
        
        user.DOB = date
        
        let dict:[String:Any] = [
            "DOB":user.DOB
        ]
        
        self.ref.child("USER").child(user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "AvailabilityVC") as! AvailabilityVC
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: SessionManager.instance.user)
                }
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
}
