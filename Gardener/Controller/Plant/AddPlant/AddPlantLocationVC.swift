//
//  AddPlantLocationVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 18.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class AddPlantLocationVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountOfWaterLbl: UILabel!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- Variables
    var editStatus :Bool = false
    var plantData = PlantModel()
    lazy var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    var delegate : getPlantData?
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions.
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if inputTextField.text!.isEmpty{
            showAlert(title: "Empty Text Field!", message: "Please enter location where your plant can grow.", controller: self)
        }else {
            if editStatus == true {
                updatePlant()
            }else {
                let filePath = self.ref?.childByAutoId().key ?? ""
                uploadImagePic(image: plantData.image, name: "", filePath: filePath)
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        itemImage.layer.cornerRadius = itemImage.frame.height/2
        itemImage.layer.borderWidth = 1.5
        itemImage.layer.borderColor = #colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1)
        itemImage.layer.masksToBounds = true
        itemImage.image = plantData.image
        nameLbl.text = plantData.primaryName
        amountOfWaterLbl.text = "Need water every \(plantData.amountOfWater) day(s)."
        frequencyLbl.text = "Need about \(plantData.frequencyOfWater) cup(s) of water."
        titleLbl.text = "Where is \(plantData.primaryName) located?"
        inputTextField.UISetupToTextField()
        saveBtn.addButtonShadow()
        
        if editStatus == true {
            inputTextField.text = plantData.location
            itemImage.sd_setImage(with: URL(string: plantData.filePath), placeholderImage: UIImage(named: "tree"))
        }
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
                showAlert(title: "Upload \(self.plantData.primaryName) Image", message: "Error: \(error.localizedDescription )", controller: self)
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
            "primaryName":plantData.primaryName,
            "secoundryName":plantData.secoundryName,
            "amountOfWater":plantData.amountOfWater,
            "frequencyOfWater":plantData.frequencyOfWater,
            "sunlight":plantData.sunlight,
            "location":inputTextField.text!,
            "userId":user.userId,
            "createdDate":date,
            "categoryName":plantData.categoryName,
            "categoryId":plantData.categoryId
        ]
        self.ref.child("Plants").child("Data").child(plantData.categoryName).child(Id).setValue(dict) { (err, dbRef) in
            if err == nil {
                self.addMyPlant(dict: dict, plantId: Id)
            }else{
                showAlert(title: "\(self.plantData.primaryName) Data", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    
    private func addMyPlant(dict:[String:Any],plantId:String){
        self.ref.child("MyPlants").child(self.user.userId).child(plantId).setValue(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = vc
            }else{
                showAlert(title: "\(self.plantData.primaryName) Data", message: "\(String(describing: err?.localizedDescription))", controller: self)
            }
        }
    }
    
    
    private func updatePlant(){
        self.view.addSubview(self.progressIndicator)
        plantData.location = inputTextField.text!
        let dict:[String:Any] = [
            "location":plantData.location
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
