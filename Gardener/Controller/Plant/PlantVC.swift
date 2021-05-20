//
//  AddPlantVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import Firebase

class PlantVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addPlantCategory: UIButton!
    
    //MARK:- Variables.
    let flowLayout = ZoomAndSnapFlowLayout()
    var array = [PlantModel]()
    var selectedPage = 0
    private var user = SessionManager.instance.userData
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    let transition = TransitionAnimator()
    private var selectedCell = UICollectionViewCell()
    
    //MARK:-  View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getProductDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedCell.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.selectedCell.isHidden = true
    }
    
    //MARK:- Actions.
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "MenuVC") as! MenuVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addPlantBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "SelectCategoryVC") as! SelectCategoryVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addPlantCategory(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddCategoryVC") as! AddCategoryVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        ref = Database.database().reference()
        addBtn.addButtonShadow()
        pageControl.hidesForSinglePage = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    private func getProductDataFromDatabase() {
        self.view.addSubview(progressIndicator)
        ref.child("MyPlants").child(user.userId).observe(.value) { (snapshot) in
            self.array.removeAll()
            self.progressIndicator.removeFromSuperview()
            if !snapshot.exists() {
                let object = PlantModel(id: "97415", filePath: "https://firebasestorage.googleapis.com/v0/b/gardener-195b4.appspot.com/o/Plants%2Fecology.png?alt=media&token=04989548-5e6d-494a-9b14-a054392564c5", fileName: "", primaryName: "Let's Get Started!", secoundryName: "", amountOfWater: "", frequencyOfWater: "", sunlight: "", location: "", userId: self.user.userId, createdDate: "", categoryName: "", categoryId: "")
                self.array.append(object)
                self.collectionView.reloadData()
                self.addBtn.isHidden = true
                self.pageControl.isHidden = true
                return
            }
            
            for child in snapshot.children {
                let snap = child as? DataSnapshot
                guard let dict = snap?.value as? NSDictionary else {
                    print("Error")
                    return
                }
                var data = PlantModel()
                data.amountOfWater = dict["amountOfWater"] as? String ?? ""
                data.categoryId = dict["categoryId"] as? String ?? ""
                data.categoryName = dict["categoryName"] as? String ?? ""
                data.createdDate = dict["createdDate"] as? String ?? ""
                data.fileName = dict["fileName"] as? String ?? ""
                data.filePath = dict["filePath"] as? String ?? ""
                data.frequencyOfWater = dict["frequencyOfWater"] as? String ?? ""
                data.id = dict["id"] as? String ?? ""
                data.location = dict["location"] as? String ?? ""
                data.primaryName = dict["primaryName"] as? String ?? ""
                data.secoundryName = dict["secoundryName"] as? String ?? ""
                data.sunlight = dict["sunlight"] as? String ?? ""
                data.userId = dict["userId"] as? String ?? ""
                self.array.append(data)
            }
            self.addBtn.isHidden = false
            self.pageControl.isHidden = false
            self.pageControl.numberOfPages = self.array.count
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }withCancel: { (error) in
            self.progressIndicator.removeFromSuperview()
            Toast.show(message: error.localizedDescription, controller: self)
        }
    }
    
    
    
    
}
extension PlantVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddPlantCollectionViewCell
        guard indexPath.row < array.count else {return cell}
        let instance = array[indexPath.row]
        if instance.primaryName.contains("Let's Get Started!"){
            cell.frequencyLbl.text = "Tap here to add a plant"
        }else {
            cell.frequencyLbl.text = "Needs water every \(instance.amountOfWater) day(s)"
        }
        cell.nameLbl.text = instance.primaryName
        
        cell.locationLbl.text = instance.location
        let imageUrl = "\(instance.filePath)"
        let encodeImage = imageUrl.replacingOccurrences(of: " ", with: "%20")
        cell.itemImage.sd_setImage(with: URL(string: encodeImage), placeholderImage: UIImage(named: "tree"))
        cell.infoBtn.addButtonShadow()
        if instance.id == "97415" {
            cell.addPlantImage.isHidden = false
            cell.infoBtn.setImage(#imageLiteral(resourceName: "addBtn"), for: .normal)
        }else {
            cell.addPlantImage.isHidden = true
            cell.infoBtn.setImage(#imageLiteral(resourceName: "info"), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("current Page =",indexPath.row)
        self.pageControl.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < array.count else {return}
        selectedCell = collectionView.cellForItem(at: indexPath) as! AddPlantCollectionViewCell
        let instance = array[indexPath.row]
        if instance.id == "97415"{
            let vc = storyboard?.instantiateViewController(identifier: "SelectCategoryVC") as! SelectCategoryVC
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }else {
            let vc = storyboard?.instantiateViewController(identifier: "PlantsDetailsVC") as! PlantsDetailsVC
            vc.data = array[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
extension PlantVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
