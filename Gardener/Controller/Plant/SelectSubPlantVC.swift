//
//  SelectSubPlantVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase

class SelectSubPlantVC: UIViewController, UISearchBarDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPlantBtn: UIButton!
   
    //MARK:- Variables.
    var category = CategoryModel()
    var array = [PlantModel]()
    var filterArray = [PlantModel]()
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    private var isFilter = false
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getProductDataFromDatabase()
    }
    
    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPlantBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "AddPlantImageVC") as! AddPlantImageVC
        vc.category = self.category
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Private Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count > 0 {
            filterArray = searchBar.text!.isEmpty ? array : array.filter{ $0.primaryName.range(of: searchBar.text!, options: .caseInsensitive) != nil }
            isFilter = true
            tableView.reloadData()
        }else {
            isFilter = false
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterArray.removeAll()
        isFilter = false
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    private func setupViews() {
        ref = Database.database().reference()
        titleLbl.text = category.name
    }
    
    
    private func getProductDataFromDatabase() {
        self.view.addSubview(progressIndicator)
        ref.child("Plants").child("Data").child(category.name).observe(.childAdded) { (snapshot) in
            if !snapshot.exists() {
                Toast.show(message: "No Category Found!", controller: self)
                return
            }
            self.progressIndicator.removeFromSuperview()
            var data = PlantModel()
            guard let dict = snapshot.value as? [String:Any] else {
                print("Error")
                return
                
            }
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } withCancel: { (error) in
            self.progressIndicator.removeFromSuperview()
            Toast.show(message: error.localizedDescription, controller: self)
        }
    }
    

}
extension SelectSubPlantVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filterArray.count
        }else {
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubCategoryTableViewCell
        if isFilter {
            guard indexPath.row < filterArray.count else {return cell}
            let instance = filterArray[indexPath.row]
            cell.nameLbl.text = instance.primaryName
            cell.itemImage.sd_setImage(with: URL(string: instance.filePath), placeholderImage: UIImage(named: "tree"))
            cell.amountOfWaterLbl.text = "Need water every \(instance.amountOfWater) days"
            cell.sunlightLbl.text = instance.sunlight
        }else {
            guard indexPath.row < array.count else {return cell}
            let instance = array[indexPath.row]
            cell.nameLbl.text = instance.primaryName
            cell.itemImage.sd_setImage(with: URL(string: instance.filePath), placeholderImage: UIImage(named: "tree"))
            cell.amountOfWaterLbl.text = "Need water every \(instance.amountOfWater) days"
            cell.sunlightLbl.text = instance.sunlight
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilter{
            let vc = storyboard?.instantiateViewController(identifier: "PlantsDetailsVC") as! PlantsDetailsVC
            vc.data = filterArray[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "PlantsDetailsVC") as! PlantsDetailsVC
            vc.data = array[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
