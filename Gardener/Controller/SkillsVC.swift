//
//  SkillsVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 13.05.21.
//

import UIKit
import Firebase

class SkillsVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var profileView: UIStackView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var wateringView: UIView!
    @IBOutlet weak var wateringBtn: UIButton!
    @IBOutlet weak var fertilizingView: UIView!
    @IBOutlet weak var fertilizingBtn: UIButton!
    @IBOutlet weak var landscapingView: UIView!
    @IBOutlet weak var landscapingBtn: UIButton!
    @IBOutlet weak var trimmingView: UIView!
    @IBOutlet weak var trimmingBtn: UIButton!
    @IBOutlet weak var plantingView: UIView!
    @IBOutlet weak var plantingBtn: UIButton!
    
    //MARK:- Variables.
    var array = ["Watering"]
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
        updateUser()
    }
    
    @objc func selectSkills(sender: UIButton){
        if sender.tag == 2 {
            if array.contains("Fertilizing") {
                sender.setImage(nil, for: .normal)
                if let index = array.firstIndex(of: "Fertilizing") {
                    array.remove(at: index)
                }
            }else {
                self.array.append("Fertilizing")
                sender.setImage(#imageLiteral(resourceName: "selectTick"), for: .normal)
            }
        }else if sender.tag == 3 {
            if array.contains("Landscaping") {
                sender.setImage(nil, for: .normal)
                if let index = array.firstIndex(of: "Landscaping") {
                    array.remove(at: index)
                }
            }else {
                sender.setImage(#imageLiteral(resourceName: "selectTick"), for: .normal)
                self.array.append("Landscaping")
            }
        }else if sender.tag == 4 {
            if array.contains("Trimming") {
                sender.setImage(nil, for: .normal)
                if let index = array.firstIndex(of: "Trimming") {
                    array.remove(at: index)
                }
            }else {
                sender.setImage(#imageLiteral(resourceName: "selectTick"), for: .normal)
                self.array.append("Trimming")
            }
        }else if sender.tag == 5 {
            if array.contains("Planting") {
                sender.setImage(nil, for: .normal)
                if let index = array.firstIndex(of: "Planting") {
                    array.remove(at: index)
                }
            }else {
                sender.setImage(#imageLiteral(resourceName: "selectTick"), for: .normal)
                self.array.append("Planting")
            }
        }
        sender.tintColor = mediumGreen
        UIView.transition(with: sender,
                          duration: 0.2,
            options: .transitionCrossDissolve,
            animations: { sender.isHighlighted = true },
            completion: nil)
        
    }
    
    //MARK:- Private Functions.
    private func setupViews(){
        ref = Database.database().reference()
        nextBtn.addButtonShadow()
        wateringView.addShadow()
        
        wateringBtn.layer.borderWidth = 1.5
        wateringBtn.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        
        landscapingView.addShadow()
        landscapingBtn.layer.borderWidth = 1.5
        landscapingBtn.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        landscapingBtn.addTarget(self, action: #selector(selectSkills(sender:)), for: .touchUpInside)
        
        fertilizingView.addShadow()
        fertilizingBtn.layer.borderWidth = 1.5
        fertilizingBtn.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        fertilizingBtn.addTarget(self, action: #selector(selectSkills(sender:)), for: .touchUpInside)
        
        trimmingView.addShadow()
        trimmingBtn.layer.borderWidth = 1.5
        trimmingBtn.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        trimmingBtn.addTarget(self, action: #selector(selectSkills(sender:)), for: .touchUpInside)
        
        plantingView.addShadow()
        plantingBtn.layer.borderWidth = 1.5
        plantingBtn.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        plantingBtn.addTarget(self, action: #selector(selectSkills(sender:)), for: .touchUpInside)
        
        let user = SessionManager.instance.userData
        profileImage.sd_setImage(with: URL(string: user.filePath), placeholderImage: UIImage(named: "profile"))
        nameLbl.text = user.firstName + " " + user.lastName
        addressLbl.text = "\(user.city), \(user.state) \(user.country)"
    }
    
    private func updateUser(){
        self.view.addSubview(progressIndicator)
        var user = SessionManager.instance.userData
        
        user.skills = array
        
        let dict:[String:Any] = [
            "skills":user.skills
        ]
        
        self.ref.child("USER").child(user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "RateVC") as! RateVC
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
