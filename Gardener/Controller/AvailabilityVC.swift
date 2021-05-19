//
//  AvailabilityVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 13.05.21.
//

import UIKit
import Firebase

class AvailabilityVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var satBtn: UIButton!
    @IBOutlet weak var sunBtn: UIButton!
    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var tueBtn: UIButton!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var thuBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK:- Variables.
    var array = [String]()
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
        if array.count == 0 {
            showAlert(type: .information, Alert: "Information", details: "Please select Availble days", controller: self, status: false)
        }else {
            updateUser()
        }
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
        }else {
            
        }
    }
    
    
    @objc func selectWeekDays(sender: UIButton){
        if sender.tag == 1 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Mo")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Mo") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 2 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Tu")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Tu") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 3 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("We")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "We") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 4 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Th")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Th") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 5 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Fr")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Fr") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 6 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Sa")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Sa") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }else if sender.tag == 7 {
            if sender.isSelected == false {
                sender.backgroundColor = mediumGreen
                sender.tintColor = mediumGreen
                sender.setTitleColor(.white, for: .selected)
                self.array.append("Su")
            }else {
                sender.backgroundColor = .white
                sender.tintColor = .white
                sender.setTitleColor(.black, for: .normal)
                if let index = array.firstIndex(of: "Su") {
                    array.remove(at: index)
                }
            }
            sender.isSelected = !sender.isSelected
        }
        UIView.transition(with: sender,
                          duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { sender.isHighlighted = true },
            completion: nil)
        if array.count >= 5 {
            self.segmentControl.selectedSegmentIndex = 1
        }else {
            self.segmentControl.selectedSegmentIndex = 0
        }
    }
    
    //MARK:- Private Functions.
    
    private func setupViews() {
        ref = Database.database().reference()
        satBtn.addShadow()
        sunBtn.addShadow()
        monBtn.addShadow()
        tueBtn.addShadow()
        wedBtn.addShadow()
        thuBtn.addShadow()
        friBtn.addShadow()
        nextBtn.addShadow()
        monBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        tueBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        wedBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        thuBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        friBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        satBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        sunBtn.addTarget(self, action: #selector(selectWeekDays(sender:)), for: .touchUpInside)
        
        let user = SessionManager.instance.userData
        profileImage.sd_setImage(with: URL(string: user.filePath), placeholderImage: UIImage(named: "profile"))
        nameLbl.text = user.firstName + " " + user.lastName
        addressLbl.text = "\(user.city), \(user.state) \(user.country)"
        
        array = user.Availability
        if user.Availability.contains("Mo"){
            monBtn.isSelected = true
            monBtn.backgroundColor = mediumGreen
            monBtn.tintColor = mediumGreen
            monBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("Tu"){
            tueBtn.isSelected = true
            tueBtn.backgroundColor = mediumGreen
            tueBtn.tintColor = mediumGreen
            tueBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("We"){
            wedBtn.isSelected = true
            wedBtn.backgroundColor = mediumGreen
            wedBtn.tintColor = mediumGreen
            wedBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("Th"){
            thuBtn.isSelected = true
            thuBtn.backgroundColor = mediumGreen
            thuBtn.tintColor = mediumGreen
            thuBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("Fr"){
            friBtn.isSelected = true
            friBtn.backgroundColor = mediumGreen
            friBtn.tintColor = mediumGreen
            friBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("Sa"){
            satBtn.isSelected = true
            satBtn.backgroundColor = mediumGreen
            satBtn.tintColor = mediumGreen
            satBtn.setTitleColor(.white, for: .selected)
        }
        if user.Availability.contains("Su"){
            sunBtn.isSelected = true
            sunBtn.backgroundColor = mediumGreen
            sunBtn.tintColor = mediumGreen
            sunBtn.setTitleColor(.white, for: .selected)
        }
        if user.jobType.lowercased() == "full time" {
            self.segmentControl.selectedSegmentIndex = 1
        }else {
            self.segmentControl.selectedSegmentIndex = 0
        }
    }
    
    
    private func updateUser(){
        self.view.addSubview(progressIndicator)
        var user = SessionManager.instance.userData
        
        user.Availability = array
        var userType = ""
        if segmentControl.selectedSegmentIndex == 0 {
            userType = "Part Time"
        }else {
            userType = "Full Time"
        }
        user.jobType = userType
        
        let dict:[String:Any] = [
            "available":user.Availability,
            "jobType": user.jobType
        ]
        
        self.ref.child("USER").child(user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "SkillsVC") as! SkillsVC
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
