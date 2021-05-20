//
//  AddPlantSunlightVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 18.05.21.
//

import UIKit
import Firebase

class AddPlantSunlightVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountOfWaterLbl: UILabel!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- Variables.
    var editStatus :Bool = false
    var plantData = PlantModel()
    var user = SessionManager.instance.userData
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
            showAlert(title: "Empty Text Field!", message: "Please enter amount of sunlight needed for plant", controller: self)
        }else {
            if editStatus == true {
                updatePlant()
            }else {
                let SB = UIStoryboard(name: "Plant", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "AddPlantLocationVC") as! AddPlantLocationVC
                plantData.sunlight = inputTextField.text!
                vc.plantData = plantData
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
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
        titleLbl.text = "How much sunlight does \(plantData.primaryName) get?"
        inputTextField.UISetupToTextField()
        saveBtn.addButtonShadow()
        
        if editStatus == true {
            inputTextField.text = plantData.sunlight
            itemImage.sd_setImage(with: URL(string: plantData.filePath), placeholderImage: UIImage(named: "tree"))
        }
    }
    
    private func updatePlant(){
        self.view.addSubview(self.progressIndicator)
        plantData.sunlight = inputTextField.text!
        let dict:[String:Any] = [
            "sunlight":plantData.sunlight
        ]
        self.ref.child("Plants").child("Data").child(plantData.categoryName).child(plantData.id).updateChildValues(dict) { (err, dbRef) in
            if err == nil {
                self.updateMyPlant(dict: dict)
            }else{
                showAlert(title: "Update \(self.plantData.primaryName) Data", message: "Error: \(err?.localizedDescription ?? "")", controller: self)
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
