//
//  SelectCategoryVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 16.05.21.
//

import UIKit
import Firebase

class SelectCategoryVC: UIViewController,UISearchBarDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestBtn: UIButton!
    
    //MARK:- Variables.
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    private var array = [CategoryModel]()
    private var filterArray = [CategoryModel]()
    private var isFilter = false
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getProductDataFromDatabase()
    }
    
    //MARK:- Actions.
    @IBAction func backBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func suggestPlantBtnTapped(_ sender: Any) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "SuggestVC") as! SuggestVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Private Functions.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count > 0 {
            filterArray = searchBar.text!.isEmpty ? array : array.filter{ $0.name.range(of: searchBar.text!, options: .caseInsensitive) != nil }
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
    
    private func setupViews(){
        ref = Database.database().reference()
        suggestBtn.addButtonShadow()
    }
    
    
    private func getProductDataFromDatabase() {
        self.view.addSubview(progressIndicator)
        ref.child("Plants").child("Category").observe(.childAdded) { (snapshot) in
            if !snapshot.exists() {
                Toast.show(message: "No Category Found!", controller: self)
                return
            }
            self.progressIndicator.removeFromSuperview()
            var data = CategoryModel()
            guard let dict = snapshot.value as? [String:Any] else {
                print("Error")
                return
                
            }
            data.filePath = dict["filePath"] as? String ?? ""
            data.imageName = dict["imageName"] as? String ?? ""
            data.id = dict["id"] as? String ?? ""
            data.name = dict["name"] as? String ?? ""
            data.userId = dict["userId"] as? String ?? ""
            
            self.array.append(data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}
extension SelectCategoryVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filterArray.count
        }else {
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryTableViewCell
        if isFilter{
            guard indexPath.row < filterArray.count else {
                return cell
            }
            let instance = filterArray[indexPath.row]
            cell.nameLbl.text = instance.name
            cell.itemImage.sd_setImage(with: URL(string: instance.filePath), placeholderImage: UIImage(named: "tree"))
        }else{
            guard indexPath.row < array.count else {
                return cell
            }
            let instance = array[indexPath.row]
            cell.nameLbl.text = instance.name
            cell.itemImage.sd_setImage(with: URL(string: instance.filePath), placeholderImage: UIImage(named: "tree"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SB = UIStoryboard(name: "Plant", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "SelectSubPlantVC") as! SelectSubPlantVC
        if isFilter {
            vc.category = filterArray[indexPath.row]
        }else {
            vc.category = array[indexPath.row]
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
