//
//  PlantsDetailsVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 17.05.21.
//

import UIKit
import Firebase
import FirebaseStorage

class PlantsDetailsVC: UIViewController {

    //MARK:- Properties.
    @IBOutlet weak var titleLbl: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var secoundryLbl: UILabel!
    @IBOutlet weak var editNameBtn: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var editImageBtn: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountOfWaterLbl: UILabel!
    @IBOutlet weak var amountOfWaterBtn: UIButton!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var frequencyLbl: UILabel!
    @IBOutlet weak var frequencyBtn: UIButton!
    @IBOutlet weak var sunlightView: UIView!
    @IBOutlet weak var sunlightLbl: UILabel!
    @IBOutlet weak var sunlightBtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var editCategoryBtn: UIButton!
    
    //MARK:- Variables.
    var data = PlantModel()
    let user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK:- Actions.
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete \(data.primaryName)", message: "Do you wish to delete \(data.primaryName) permanantly?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc func categoryBtnTapped(sender: UIButton){
       
    }
    
    @IBAction func feedbackBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "FeedbackVC") as! FeedbackVC
        vc.plantData = data
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantLocationVC") as! AddPlantLocationVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func sunlightBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantSunlightVC") as! AddPlantSunlightVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func amountOfWaterBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantWaterAmountVC") as! AddPlantWaterAmountVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func editImageBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantImageVC") as! AddPlantImageVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func editNameBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantNameVC") as! AddPlantNameVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func frequencyBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantFrequencyVC") as! AddPlantFrequencyVC
        vc.editStatus = true
        vc.plantData = data
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private Functions.
    private func setupViews() {
        ref = Database.database().reference()
        editNameBtn.addButtonShadow()
        editImageBtn.addButtonShadow()
        amountView.addShadow()
        amountOfWaterBtn.addButtonShadow()
        frequencyView.addShadow()
        frequencyBtn.addButtonShadow()
        sunlightView.addShadow()
        sunlightBtn.addButtonShadow()
        locationView.addShadow()
        locationBtn.addButtonShadow()
        feedbackView.addShadow()
        feedbackBtn.addButtonShadow()
        categoryView.addShadow()
        editCategoryBtn.addButtonShadow()
        editCategoryBtn.isHidden = true
        //TODO:- Show Data
        self.nameLbl.text = data.primaryName
        self.secoundryLbl.text = data.secoundryName
        self.itemImage.sd_setImage(with: URL(string: data.filePath), placeholderImage: UIImage(named: "tree"))
        self.amountOfWaterLbl.text = "Need water every \(data.amountOfWater) day(s)"
        self.frequencyLbl.text = "Need about \(data.frequencyOfWater) cup(s) of water"
        self.sunlightLbl.text = data.sunlight
        self.locationLbl.text = data.location
        self.categoryLbl.text = data.categoryName
        
        if self.data.userId == user.userId {
            editNameBtn.isHidden = false
            editImageBtn.isHidden = false
            amountOfWaterBtn.isHidden = false
            frequencyBtn.isHidden = false
            sunlightBtn.isHidden = false
            locationBtn.isHidden = false
            feedbackView.isHidden = true
            deleteBtn.isHidden = false
        }else {
            editNameBtn.isHidden = true
            editImageBtn.isHidden = true
            amountOfWaterBtn.isHidden = true
            frequencyBtn.isHidden = true
            sunlightBtn.isHidden = true
            locationBtn.isHidden = true
            feedbackView.isHidden = false
            deleteBtn.isHidden = true
        }
    }
    
    private func deleteImage() {
        self.view.addSubview(progressIndicator)
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Plants").child(data.fileName)
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                showAlert(title: "Delete Image", message: "\(String(describing: error.localizedDescription))", controller: self)
            } else {
                // File deleted successfully
                self.deletePlant()
            }
        }
    }
    
    private func deletePlant(){
        self.ref.child("Plants").child("Data").child(data.categoryName).child(data.id).removeValue { (error, ref) in
            if error == nil {
                self.deleteMyPlant()
            }else {
                showAlert(title: "Deleting \(self.data.primaryName) Data", message: "Error: \(error?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    
    private func deleteMyPlant(){
        self.ref.child("MyPlants").child(data.userId).child(data.id).removeValue { (error, ref) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }else {
                showAlert(title: "Deleting \(self.data.primaryName) Data", message: "Error: \(error?.localizedDescription ?? "")", controller: self)
            }
        }
    }
    
    
}
extension PlantsDetailsVC: getPlantData {
    func push(_ data: PlantModel) {
        self.data = data
        self.setupViews()
    }
    
    
}
