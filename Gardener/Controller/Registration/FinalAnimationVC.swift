//
//  FinalAnimationVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase

class FinalAnimationVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var eclipseImg: UIImageView!
    @IBOutlet weak var canImage: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var succefullyMessageLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!

    //MARK:- Variables.
    var user = UserModel()
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:-Private Function
    
    private func setupViews(){
        ref = Database.database().reference()
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.layer.borderWidth = 2.0
        profileImg.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        profileImg.layer.masksToBounds = true
        
        self.nameLbl.text = "\(user.firstName) \(user.lastName)"
        self.addressLbl.text = "\(user.city) \(user.state), \(user.country) \(user.postalCode)"
        user.isUserVerified = false
        self.user.isPhoneVerified = false
        if user.role == "U" {
            self.succefullyMessageLbl.text = MsgForUser
            self.user.isProfileCompleted = true
        }else {
            self.succefullyMessageLbl.text = MsgForWC
            self.user.isProfileCompleted = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let dict:[String:Any] = [
                "isProfileCompleted":self.user.isProfileCompleted,
                "isUserVerified":self.user.isUserVerified,
                "isPhoneVerified": self.user.isPhoneVerified
            ]
            self.ref.child("USER").child(self.user.userId).updateChildValues(dict) { (err, dbRef) in
                if err == nil {
                    SessionManager.instance.logout()
                }else{
                    showAlert(title: "Registration", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
                }
            }
        }
    }
}
