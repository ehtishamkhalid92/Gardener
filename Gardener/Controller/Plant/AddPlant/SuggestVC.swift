//
//  SuggestVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase

class SuggestVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK:- Variables.
    lazy var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
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
            showAlert(title: "Empty Text!", message: "Please write suggestion to send message to the Gardener work team.", controller: self)
        }else {
            self.view.endEditing(true)
            sendsuggessionToAdmin()
        }
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        sendBtn.addButtonShadow()
        cardView.layer.cornerRadius = 10
        cardView.layer.borderWidth = 2.0
        cardView.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
    }
    
    private func sendsuggessionToAdmin(){
        self.view.addSubview(progressIndicator)
        let Id = self.ref?.childByAutoId().key ?? ""
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let time = df.string(from: Date())
        let dict:[String:Any] = [
            "id" : Id,
            "userId":user.userId,
            "text":textView.text!,
            "createdDate": time
        ]
        self.ref.child("Suggest").child(Id).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let alert = UIAlertController(title: "Thank you for suggestion", message: "Message send to the Gardening Team. Some one from team review your suggestion.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                showAlert(title: "suggestion", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    

}
