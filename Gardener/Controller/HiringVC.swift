//
//  JobVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit

class HiringVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SessionManager.instance.userData.role == "G" {
            titleLbl.text = "My Jobs"
        }
    }
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    

}
