//
//  AlertViewController.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 08.05.21.

import UIKit

enum AlertType {
    case success
    case information
    case Warning
    case error
}

class AlertViewController: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var popUPView: UIView!
    @IBOutlet weak var circlerView: UIView!
    @IBOutlet weak var innerCircleView: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var yesBtn: UIButton!
    
    //MARK:- Variables
    var type : AlertType?
    var alert :String?
    var details :String?
    var status = false
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        applyAlertFunctionality()
    }
    
    private func setupViews() {
        doneBtn.addButtonShadow()
        popUPView.layer.cornerRadius = 5.0
        popUPView.layer.shadowColor = UIColor.black.cgColor
        popUPView.layer.shadowOpacity = 0.5
        popUPView.layer.shadowOffset = .zero
        popUPView.layer.shadowRadius = 5
        
        circlerView.layer.cornerRadius = circlerView.frame.height / 2
        circlerView.layer.shadowColor = UIColor.black.cgColor
        circlerView.layer.shadowOpacity = 0.5
        circlerView.layer.shadowOffset = .zero
        circlerView.layer.shadowRadius = 5.0
        
        innerCircleView.layer.cornerRadius = innerCircleView.frame.height / 2
        self.headingLbl.text = alert
        self.descriptionLbl.text = details
        if status == true {
            yesBtn.addButtonShadow()
            yesBtn.isHidden = false
            yesBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
            doneBtn.setTitle("No", for: .normal)
        }
    }
    
    private func applyAlertFunctionality() {
        switch type {
        case .success:
            print("Sucess")
            self.innerCircleView.backgroundColor = mediumGreen
            self.checkImage.image = #imageLiteral(resourceName: "check-mark")
        case .information:
            print("Information")
            self.innerCircleView.backgroundColor = silver
            self.checkImage.image = #imageLiteral(resourceName: "info")
        case .Warning:
            print("Warning")
            self.innerCircleView.backgroundColor = SafetyYellow
            self.checkImage.image = #imageLiteral(resourceName: "warning")
        case .error:
            print("Error")
            self.innerCircleView.backgroundColor = RedOrange
            self.checkImage.image = #imageLiteral(resourceName: "error")
        case .none:
            print("nothing selected")
        }
    }
    
    @IBAction func dontBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func logout(){
        SessionManager.instance.logout()
    }
}
func showAlertView(alertType:AlertType,title:String,message:String,controller:UIViewController){
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let alertVC = sb.instantiateViewController(identifier: "AlertViewController") as! AlertViewController
    alertVC.type = alertType
    alertVC.alert = title
    alertVC.details = message
    alertVC.modalPresentationStyle = .overFullScreen
    controller.present(alertVC, animated: true, completion: nil)
}
