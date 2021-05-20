//
//  AddPlantVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase

class AddPlantImageVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemImageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK:- Variables.
    var category = CategoryModel()
    var selectedImage : UIImage?
    var plantData = PlantModel()
    var editStatus = false
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    var delegate: getPlantData?
    
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
            showAlert(title: "Image not selected!", message: "Please select plant image to continie", controller: self)
        }else {
            if editStatus == true {
                deleteImage()
            }else {
                let SB = UIStoryboard(name: "Plant", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "AddPlantNameVC") as! AddPlantNameVC
                var data = PlantModel()
                data.image = selectedImage!
                data.categoryId = category.id
                data.categoryName = category.name
                vc.plantData = data
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
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
        
        if editStatus == true {
            self.itemImage.sd_setImage(with: URL(string: plantData.filePath), placeholderImage: UIImage(named: "tree"))
        }
    }
    
    private func deleteImage() {
        self.view.addSubview(progressIndicator)
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Plants").child(plantData.fileName)
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                showAlert(title: "Delete \(self.plantData.primaryName) Image", message: "\(String(describing: error.localizedDescription))", controller: self)
            } else {
                // File deleted successfully
                self.updateImage(image: self.selectedImage!)
            }
        }
    }
    
    func updateImage(image: UIImage) {
        guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let filePath = self.ref?.childByAutoId().key ?? ""
        let storageRef = Storage.storage().reference(withPath: "Plants/\(filePath)")
        
        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                showAlert(title: "Update \(self.plantData.primaryName) Image", message: "\(String(describing: error.localizedDescription))", controller: self)
                return
            }
            
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                print(url?.absoluteString ?? "") // <- Download URL
                self.updatePlant(imageString: url?.absoluteString ?? "", filePath: filePath)
            })
        }
    }
    
    private func updatePlant(imageString:String,filePath:String){
        self.plantData.filePath = imageString
        self.plantData.fileName = filePath
        let dict:[String:Any] = [
            "filePath":self.plantData.filePath,
            "fileName":self.plantData.fileName,
        ]
        self.ref.child("Plants").child("Data").child(plantData.categoryName).child(plantData.id).updateChildValues(dict) { (err, dbRef) in
            if err == nil {
                self.updateMyPlant(dict: dict)
            }else{
                showAlert(title: "Update \(self.plantData.primaryName) Data", message: "\(String(describing: err?.localizedDescription))", controller: self)
            }
        }
    }
    
    private func updateMyPlant(dict:[String:Any]){
        self.ref.child("MyPlants").child(plantData.userId).child(plantData.id).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                self.delegate?.push(self.plantData)
                self.dismiss(animated: true, completion: nil)
            }else{
                showAlert(title: "Update \(self.plantData.primaryName) Data", message: "\(String(describing: err?.localizedDescription))", controller: self)
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
