//
//  RegistrationStepFourVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class RegistrationStepFourVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variables
    var selectedImage : UIImage?
    lazy var user = UserModel()
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    

    //MARK:- Actions.
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "RegistrationFinalStepVC") as! RegistrationFinalStepVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        if self.selectedImage != nil {
            let SB = UIStoryboard(name: "Main", bundle: nil)
            let vc = SB.instantiateViewController(identifier: "RegistrationFinalStepVC") as! RegistrationFinalStepVC
            vc.selectedImage = self.selectedImage!
            vc.user = self.user
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }else {
            showAlert(title: "Image not selected!", message: "Please select image to continue.", controller: self)
        }
      
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func profileImageTapped(sender: UITapGestureRecognizer){
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
    
    //MARK:- Private Functions
    func uploadImagePic(image: UIImage, name: String, filePath: String) {
        self.view.addSubview(progressIndicator)
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"

        let storageRef = Storage.storage().reference(withPath: "Profile/\(filePath)")

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                showAlert(title: "Upload Image", message: "\(String(describing: error.localizedDescription))", controller: self)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "") // <- Download URL
                self.updateUser(imageString: url?.absoluteString ?? "", filePath: filePath)
            })
        }
    }
    
    private func updateUser(imageString:String,filePath:String){
        user.filePath = imageString
        user.fileName = filePath
        let dict:[String:Any] = [
            "filePath":user.filePath,
            "imageName":user.fileName
        ]
        self.ref.child("USER").child(self.user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "RegistrationFinalStepVC") as! RegistrationFinalStepVC
                vc.user = self.user
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(title: "Update \(self.user.firstName) Data", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    
    private func setupViews() {
        ref = Database.database().reference()
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        profileImage.layer.masksToBounds = true
    
        nextBtn.addButtonShadow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(sender:)))
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.addGestureRecognizer(tap)
    }

}
//TODO: UIImagePickerControllerDelegate
extension RegistrationStepFourVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.profileImage.image = image
            self.selectedImage = image
        }
        
    }
}
