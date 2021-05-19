//
//  AddPlantNameVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 18.05.21.
//

import UIKit
import Firebase

class AddPlantNameVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var primaryNameTextField: UITextField!
    @IBOutlet weak var secoundryNameTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    //MARK:- Variables.
    var editStatus :Bool = false
    var plantData = PlantModel()
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
        if primaryNameTextField.text!.isEmpty{
            showAlert(type: .information, Alert: "Add Plant", details: "Please write Primary Name", controller: self, status: false)
        }else if secoundryNameTextField.text!.isEmpty {
            showAlert(type: .information, Alert: "Add Plant", details: "Please write Secoundry Name.", controller: self, status: false)
        }else{
            if editStatus == true {
                updatePlant()
            }else {
                let SB = UIStoryboard(name: "Plant", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "AddPlantWaterAmountVC") as! AddPlantWaterAmountVC
                plantData.primaryName = primaryNameTextField.text!
                plantData.secoundryName = secoundryNameTextField.text!
                vc.plantData = plantData
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        ref = Database.database().reference()
        saveBtn.addButtonShadow()
        primaryNameTextField.UISetupToTextField()
        secoundryNameTextField.UISetupToTextField()
        if editStatus == true {
            primaryNameTextField.text = plantData.primaryName
            secoundryNameTextField.text = plantData.secoundryName
        }
    }
    
    private func updatePlant(){
        plantData.primaryName = primaryNameTextField.text!
        plantData.secoundryName = secoundryNameTextField.text!
        let dict:[String:Any] = [
            "primaryName":plantData.primaryName,
            "secoundryName":plantData.secoundryName,
        ]
        self.ref.child("Plants").child("Data").child(plantData.categoryName).child(plantData.id).updateChildValues(dict) { (err, dbRef) in
            if err == nil {
                self.updateMyPlant(dict: dict)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
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
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
}
