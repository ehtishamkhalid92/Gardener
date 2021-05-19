//
//  AddPlantVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class AddPlantImageVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemImageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- Variables.
    var category = CategoryModel()
    var selectedImage : UIImage?
    lazy var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if self.selectedImage == nil {
            showAlert(type: .information, Alert: "Add Plant", details: "Please select image", controller: self, status: false)
        }else {
            let filePath = self.ref?.childByAutoId().key ?? ""
            uploadImagePic(image: self.selectedImage!, name: "", filePath: filePath)
        }
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
    
    //MARK:- Private Function.
    private func setupViews() {
        ref = Database.database().reference()
        saveBtn.addButtonShadow()
        
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.layer.borderWidth = 3.0
        itemImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        itemImage.layer.masksToBounds = true
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(sender:)))
        self.itemImage.isUserInteractionEnabled = true
        self.itemImage.addGestureRecognizer(tap)
        
        
    }
    
    
    func uploadImagePic(image: UIImage, name: String, filePath: String) {
        self.view.addSubview(progressIndicator)
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"

        let storageRef = Storage.storage().reference(withPath: "Plants/\(filePath)")

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: error.localizedDescription))", controller: self, status: false)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "") // <- Download URL
                self.addPlant(imageString: url?.absoluteString ?? "", filePath: filePath)
            })
        }
    }

    private func addPlant(imageString:String,filePath:String){
        let Id = self.ref?.childByAutoId().key ?? ""
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = df.string(from: Date())
        let dict:[String:Any] = [
            "id":Id,
            "filePath":imageString,
            "fileName":filePath,
//            "primaryName":primaryNameTextField.text!,
//            "secoundryName":secoundryNameTextField.text!,
//            "amountOfWater":amountOfWaterTextField.text!,
//            "frequencyOfWater":frequencyOfWaterTextField.text!,
//            "sunlight":sunlightTextField.text!,
//            "location":locationTextField.text!,
            "userId":self.user.userId,
            "createdDate":date,
            "categoryName":self.category.name,
            "categoryId":self.category.id
        ]
        self.ref.child("Plants").child("Data").child(category.name).child(Id).setValue(dict) { (err, dbRef) in
            if err == nil {
                self.addMyPlant(dict: dict, plantId: Id)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
    
    private func addMyPlant(dict:[String:Any],plantId:String){
        self.ref.child("MyPlants").child(self.user.userId).child(plantId).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                self.dismiss(animated: true, completion: nil)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
    
    
}
extension AddPlantImageVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.itemImage.image = image
            self.selectedImage = image
        }
        
    }
}
