//
//  AddCategoryVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class AddCategoryVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var addplantImageBtn: UIButton!
    
    //MARK:- Variables.
    var selectedImage : UIImage?
    lazy var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK;- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    

    //MARK:- Actions.
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if self.selectedImage == nil {
            showAlert(title: "Image Not Selected!", message: "Please select image to continue", controller: self)
        }else if self.nameTextField.text!.isEmpty{
            showAlert(title: "Empty Text Field!", message: "Please enter name of the plant in the text field.", controller: self)
        }else {
            let filePath = self.ref?.childByAutoId().key ?? ""
            uploadImagePic(image: self.selectedImage!, name: "", filePath: filePath)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

        let storageRef = Storage.storage().reference(withPath: "Plants/\(filePath)")

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                showAlert(title: "Upload Image", message: "\(String(describing: error.localizedDescription))", controller: self)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "") // <- Download URL
                self.addCategory(imageString: url?.absoluteString ?? "", filePath: filePath)
            })
        }
    }
    
    private func addCategory(imageString:String,filePath:String){
        let Id = self.ref?.childByAutoId().key ?? ""
        let dict:[String:Any] = [
            "filePath":imageString,
            "imageName":filePath,
            "id" : Id,
            "userId":user.userId,
            "name":nameTextField.text!
        ]
        self.ref.child("Plants").child("Category").child(Id).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                Toast.show(message: "Successfully Added", controller: self)
                self.dismiss(animated: true, completion: nil)
            }else{
                showAlert(title: "Add Category", message: "\(String(describing: err?.localizedDescription))", controller: self)
            }
        }
    }
    
    private func setupViews(){
        saveBtn.addButtonShadow()
        
        ref = Database.database().reference()
        plantImage.layer.cornerRadius = plantImage.frame.height/2
        plantImage.layer.borderWidth = 3.0
        plantImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        plantImage.layer.masksToBounds = true
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(sender:)))
        self.plantImage.isUserInteractionEnabled = true
        self.plantImage.addGestureRecognizer(tap)
        
        self.nameTextField.UISetupToTextField()
    }
}
//TODO: UIImagePickerControllerDelegate
extension AddCategoryVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage {
            self.plantImage.image = image
            self.selectedImage = image
        }
        
    }
}
