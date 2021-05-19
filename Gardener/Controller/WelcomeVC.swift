//
//  ViewController.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 08.05.21.
//

import UIKit

class WelcomeVC: UIViewController {

    //MARK:- View Life Cycle.
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var wateringImage: UIImageView!
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subheadingLbl: UILabel!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
//        animate()
        setupViews()
    }

    //MARK:- Actions
    
    @IBAction func createAnAccount(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "RegistrationStepOneVC") as! RegistrationStepOneVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        showAlert(type: .information, Alert: "Data Limited Exceeded!", details: "Please subscribe to Diamond you data limited ended you have left only 1 GB", controller: self)
    }
    
    //MARK:- Private Functions.
    
    private func setupViews() {
        createAccountBtn.layer.cornerRadius = createAccountBtn.frame.height/2
        createAccountBtn.addButtonShadow()
    }
    
//    private func animate() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//             UIView.transition(with: self.wateringImage,
//                               duration: 1.0,
//                                     animations: {
//                                       self.wateringImage.frame.origin.y  -= 100
//                                        self.appNameLbl.frame.origin.y -= 100
//                                        self.headingLbl.frame.origin.y -= 100
//                                        self.subheadingLbl.frame.origin.y -= 100
//                   }, completion: nil)
//        })
//    }
}

