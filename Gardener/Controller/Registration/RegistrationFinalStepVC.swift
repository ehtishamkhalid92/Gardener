//
//  RegistrationFinalStepVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase

class RegistrationFinalStepVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var landlordView: UIView!
    @IBOutlet weak var gardenerView: UIView!
    

    //MARK:- Variables.
    var user = UserModel()
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func landlordBtnTapped(sender: UITapGestureRecognizer){
        UpdateUser(userType: "U")
    }
    
    @objc func gardenerBtnTapped(sender: UITapGestureRecognizer){
        UpdateUser(userType: "G")
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        ref = Database.database().reference()
        landlordView.addShadow()
        gardenerView.addShadow()
        let land = UITapGestureRecognizer(target: self, action: #selector(landlordBtnTapped(sender:)))
        self.landlordView.isUserInteractionEnabled = true
        self.landlordView.addGestureRecognizer(land)
        
        let gardener = UITapGestureRecognizer(target: self, action: #selector(gardenerBtnTapped(sender:)))
        self.gardenerView.isUserInteractionEnabled = true
        self.gardenerView.addGestureRecognizer(gardener)
    }
    
    private func UpdateUser(userType:String){
        self.view.addSubview(progressIndicator)
        user.role = userType
        let dict:[String:Any] = [
            "role":user.role
        ]
        self.ref.child("USER").child(self.user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "FinalAnimationVC") as! FinalAnimationVC
                vc.user = self.user
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
    
}
