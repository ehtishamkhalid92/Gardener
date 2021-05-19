//
//  FeedbackVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 19.05.21.
//

import UIKit
import Firebase

class FeedbackVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK:- Variables.
    lazy var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    var plantData = PlantModel()
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        if textView.text.isEmpty {
            showAlert(type: .information, Alert: "Information", details: "Pleasw write something", controller: self, status: false)
            self.textView.becomeFirstResponder()
        }else {
            self.view.endEditing(true)
            sendFeedbackToAdmin()
        }
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        sendBtn.addButtonShadow()
        cardView.layer.cornerRadius = 10
        cardView.layer.borderWidth = 2.0
        cardView.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        headingLbl.text = "Feedback on \(plantData.primaryName)"
    }
    
    private func sendFeedbackToAdmin(){
        let Id = self.ref?.childByAutoId().key ?? ""
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let time = df.string(from: Date())
        let dict:[String:Any] = [
            "id" : Id,
            "userId":user.userId,
            "text":textView.text!,
            "createdDate": time,
            "plantId": plantData.id,
            "plantCategory": plantData.categoryName
        ]
        self.ref.child("Feedback").child(Id).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                self.textView.text = ""
                showAlert(type: .success, Alert: "Thank you for Feedback", details: "Message send to the Gardening Team. Some one from team review the feedback.", controller: self, status: false)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }

}
