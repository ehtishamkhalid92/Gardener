//
//  JobVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit

class HiringVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var findGardenerBtn: UIButton!
    
    
    //MARK:- Variables.
    var user = SessionManager.instance.userData
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK:- Actions.
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func SegmentControlTapped(_ sender: CustomSegmentedControl) {
        if user.role == "G" {
            if sender.selectedSegmentIndex == 0 {
                alertImage.image = #imageLiteral(resourceName: "offer")
                alertLbl.text = "No Offer Yet!"
            }else {
                alertImage.image = #imageLiteral(resourceName: "noJob")
                alertLbl.text = "No Job Yet!"
            }
        }else {
            if sender.selectedSegmentIndex == 0 {
                alertImage.image = #imageLiteral(resourceName: "jobRequest")
                alertLbl.text = "No Job Requested!"
            }else {
                alertImage.image = #imageLiteral(resourceName: "Hired")
                alertLbl.text = "No Gardener Hired!"
            }
        }
    }
    
    @IBAction func findGardenerBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Hiring", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "JobRequestStepOneVC") as! JobRequestStepOneVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        findGardenerBtn.addButtonShadow()
        if user.role == "G" {
            findGardenerBtn.isHidden = true
            titleLbl.text = "My Jobs"
            alertImage.image = #imageLiteral(resourceName: "offer")
            alertLbl.text = "No Offer Yet!"
            segmentControl.setTitle("Offer's", forSegmentAt: 0)
            segmentControl.setTitle("Job's", forSegmentAt: 1)
        }else {
            findGardenerBtn.isHidden = false
        }
        
    }
    
}
