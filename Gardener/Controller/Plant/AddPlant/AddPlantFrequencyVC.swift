//
//  AddPlantFrequencyVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 18.05.21.
//

import UIKit
import Firebase

class AddPlantFrequencyVC: UIViewController, UITextFieldDelegate {

    //MARK:- Properties.
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var wateringView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
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
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if inputTextField.text!.isEmpty || Int(inputTextField.text!) == 0 {
            showAlert(type: .information, Alert: "Add Plant", details: "Please write Frequency of water.", controller: self, status: false)
        }else {
            if editStatus == true {
                updatePlant()
            }else {
                let SB = UIStoryboard(name: "Plant", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "AddPlantSunlightVC") as! AddPlantSunlightVC
                plantData.frequencyOfWater = inputTextField.text!
                vc.plantData = plantData
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    private func setupViews() {
        ref = Database.database().reference()
        saveBtn.addButtonShadow()
        inputTextField.addUnderLine()
        wateringView.addShadow()
        inputTextField.becomeFirstResponder()
        inputTextField.delegate = self
        if editStatus == true {
            self.inputTextField.text = plantData.frequencyOfWater
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         let newLength = text.count + string.count - range.length
         return newLength <= 3
    }
    
    private func updatePlant(){
        self.view.addSubview(self.progressIndicator)
        plantData.frequencyOfWater = inputTextField.text!
        let dict:[String:Any] = [
            "frequencyOfWater":plantData.frequencyOfWater
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
