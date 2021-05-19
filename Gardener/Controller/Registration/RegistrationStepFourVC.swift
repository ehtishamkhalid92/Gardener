//
//  RegistrationStepFourVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit

class RegistrationStepFourVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variables
    lazy var selectedImage = UIImage()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    

    //MARK:- Actions.
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        
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
    private func setupViews() {
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
