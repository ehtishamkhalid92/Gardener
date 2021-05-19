//
//  MenuVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 15.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class MenuVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //MARK:- Variables.
    var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Image Selection", message: "Select Image From", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        if sender.isOn{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.scheduleNotification(title: "", body: "Notification Enabled")
            self.user.notification = true
        }else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.scheduleNotification(title: "", body: "Notification Disabled")
            self.user.notification = false
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: SessionManager.instance.user)
        }
    }
    
    @objc func logout(sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: "Gardener Work", message: "Do you want to logout from the application?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            SessionManager.instance.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 5.0
        profileImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        profileImage.layer.masksToBounds = true
        editProfileBtn.addButtonShadow()
        editProfileView.addShadow()
        paymentView.addShadow()
        notificationView.addShadow()
        termView.addShadow()
        privacyView.addShadow()
        contactView.addShadow()
        logoutView.addShadow()
        
        profileImage.sd_setImage(with: URL(string: user.filePath), placeholderImage: UIImage(named: "profile"))
        nameLbl.text = user.firstName + " " + user.lastName
        addressLbl.text = "\(user.city), \(user.state) \(user.country)"
        
        let logout = UITapGestureRecognizer(target: self, action: #selector(logout(sender:)))
        self.logoutView.isUserInteractionEnabled = true
        self.logoutView.addGestureRecognizer(logout)
        
        if user.notification == true {
            notificationSwitch.isOn = true
        }else{
            notificationSwitch.isOn = false
        }
    }
    
    private func deleteImage(imageURl:String,image: UIImage) {
        self.view.addSubview(progressIndicator)
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Profile").child(imageURl)
        print(storageRef)
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                print(error)
                showAlert(type: .error, Alert: "Error", details: error.localizedDescription, controller: self, status: false)
            } else {
                // File deleted successfully
                let filePath = self.ref?.childByAutoId().key ?? ""
                self.uploadImagePic(image: image, name: "", filePath: filePath)
            }
        }
    }
    
    func uploadImagePic(image: UIImage, name: String, filePath: String) {
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"

        let storageRef = Storage.storage().reference(withPath: "Profile/\(filePath)")

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: error.localizedDescription))", controller: self, status: false)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "") // <- Download URL
                self.updateUser(imageString: url?.absoluteString ?? "", imageId: filePath)
            })
        }
    }
    
    private func updateUser(imageString:String,imageId:String){
        user.filePath = imageString
        user.imageName = imageId
        let dict:[String:Any] = [
            "filePath":user.filePath,
            "imageName":user.imageName
        ]
        self.ref.child("USER").child(self.user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(self.user) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: SessionManager.instance.user)
                }
                Toast.show(message: "Successfully Updated", controller: self)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
    
    
    
    
    
}
extension MenuVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.profileImage.image = image
            self.deleteImage(imageURl: user.imageName, image: image)
        }
        
    }
}
