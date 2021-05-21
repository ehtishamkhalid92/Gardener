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
    var selectedImage = UIImage()
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
        CreateUser(userType: "U")
    }
    
    @objc func gardenerBtnTapped(sender: UITapGestureRecognizer){
        CreateUser(userType: "G")
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
    
    private func CreateUser(userType:String){
        self.user.role = userType
        self.view.addSubview(progressIndicator)
        Auth.auth().createUser(withEmail: self.user.email, password: self.user.password) { authResult, error in
            self.progressIndicator.removeFromSuperview()
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    showAlert(title: "Operation Not Allowed", message: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section", controller: self)
                case .emailAlreadyInUse:
                    showAlert(title: "Email Already In Use", message: "The email address is already in use by another account", controller: self)
                case .invalidEmail:
                    showAlert(title: "Invalid Email", message: "The email address is badly formatted", controller: self)
                case .weakPassword:
                    showAlert(title: "Weak Password", message: "The password must be 6 characters long or more", controller: self)
                default:
                    showAlert(title: "Registration", message: "Error: \(error.localizedDescription)", controller: self)
                }
            } else {
                let newUserInfo = Auth.auth().currentUser
                let userId = newUserInfo?.uid
                self.user.userId = userId!
                self.uploadProfileImagePic()
            }
        }
    }
    
    func uploadProfileImagePic() {
        self.view.addSubview(progressIndicator)
        guard let imageData: Data = self.selectedImage.jpegData(compressionQuality: 0.1) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let imageId = self.ref?.childByAutoId().key ?? ""
        let storageRef = Storage.storage().reference(withPath: "Profile/\(imageId)")

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                showAlert(title: "Upload Image", message: "\(String(describing: error.localizedDescription))", controller: self)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "")
                self.user.fileName = imageId
                self.user.filePath = url?.absoluteString ?? ""
                self.addUserChildData()
            })
        }
    }
    
    private func addUserChildData(){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = df.string(from: Date())
        user.date = date
        user.isPhoneVerified = false
        let dict :[String:Any] = [
            "userID": self.user.userId,
            "date":self.user.date,
            "firstName": self.user.firstName,
            "lastName": self.user.lastName,
            "email":self.user.email,
            "countryCode": self.user.countryCode,
            "phoneNumber": self.user.phoneNumber,
            "filePath": self.user.filePath,
            "imageName": self.user.fileName,
            "postalCode": self.user.postalCode,
            "address":self.user.address,
            "city": self.user.city,
            "country": self.user.country,
            "state": self.user.state,
            "longitude": self.user.longitude,
            "latitude": self.user.latitude,
            "role": self.user.role,
        ]
        self.ref.child("USER").child(self.user.userId).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "FinalAnimationVC") as! FinalAnimationVC
                vc.user = self.user
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(title: "Registration", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    
}
