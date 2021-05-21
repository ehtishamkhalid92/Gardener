//
//  ProfileDetailsVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 20.05.21.
//

import UIKit
import MapKit

class ProfileDetailsVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editNameBtn: UIButton!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var editEmailBtn: UIButton!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var editPhoneNumberBtn: UIButton!
    @IBOutlet weak var DOBView: UIView!
    @IBOutlet weak var DOBLbl: UILabel!
    @IBOutlet weak var editDOBBtn: UIButton!
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var editAvailabilityBtn: UIButton!
    @IBOutlet weak var jobTypeSegment: CustomSegmentedControl!
    @IBOutlet var weekDaysBtn: [UIButton]!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var editSkillBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ratesView: UIView!
    @IBOutlet weak var editRatesBtn: UIButton!
    @IBOutlet weak var hourlyLbl: UILabel!
    @IBOutlet weak var oneToFiveLbl: UILabel!
    @IBOutlet weak var sixToFifteenLbl: UILabel!
    @IBOutlet weak var sixteenPlusLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var editLocationBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    
    //MARK:- Variables.
    private var userData = UserModel()
    let locationManager = CLLocationManager()
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userData = SessionManager.instance.userData
        showUserContent()
    }
    
    
    //MARK:- Actions.
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editNameBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "RegistrationStepOneVC") as! RegistrationStepOneVC
        vc.editStatus = true
        vc.user = self.userData
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func editEmailBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func editPhoneBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func editDOBBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "dateOfBirthVC") as! dateOfBirthVC
        vc.editStatus = true
        vc.userData = self.userData
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func availabilityBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func editSkillsBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func editRatesBtnTapped(_ sender: UIButton) {
        
    }
    @IBAction func editLocationBtnTapped(_ sender: UIButton) {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let vc = SB.instantiateViewController(identifier: "RegistrationStepThreeVC") as! RegistrationStepThreeVC
        vc.editStatus = true
        vc.user = self.userData
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deleteBtnTapped(sender: UIButton){
        let alert = UIAlertController(title: "Delete Account", message: "Do you wish to delete your account permanantly?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
//            self.deleteImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK:- PRivate Functions.
    private func setupViews() {
        editNameBtn.addButtonShadow()
        editEmailBtn.addButtonShadow()
        editPhoneNumberBtn.addButtonShadow()
        editDOBBtn.addButtonShadow()
        editAvailabilityBtn.addButtonShadow()
        editSkillBtn.addButtonShadow()
        editRatesBtn.addButtonShadow()
        editLocationBtn.addButtonShadow()
        deleteAccountBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        for item in weekDaysBtn {
            item.addButtonShadow()
        }
    }
    
    private func showUserContent() {
        if self.userData.role == "U" {
            self.DOBView.isHidden = true
            self.availableView.isHidden = true
            self.skillView.isHidden = true
            self.ratesView.isHidden = true
        }
        self.nameLbl.text = "\(userData.firstName) \(userData.lastName)"
        self.emailLbl.text = "\(userData.email)"
        let countryCode = userData.countryCode
        let decomposedCountryCode = countryCode.components(separatedBy: " ")
        if decomposedCountryCode.count > 0 {
            self.phoneNumberLbl.text = "\(decomposedCountryCode[1]) \(userData.phoneNumber)"
        }
        if userData.DOB != "" {
            let age = calcAge(birthday: "\(userData.DOB)")
            self.DOBLbl.text = "\(userData.DOB) (\(age) years)"
        }
        self.locationLbl.text = "\(self.userData.address) \n\(self.userData.city), \(self.userData.state) \(self.userData.country)"
        if userData.jobType == "Full Time" {
            jobTypeSegment.selectedSegmentIndex = 1
        }else {
            jobTypeSegment.selectedSegmentIndex = 0
        }
        if userData.Availability.count > 0 {
            for item in userData.Availability {
                if item == "Sa"{
                    weekDaysBtn[0].backgroundColor = mediumGreen
                    weekDaysBtn[0].tintColor = mediumGreen
                    weekDaysBtn[0].setTitleColor(.white, for: .normal)
                }else if item == "Su" {
                    weekDaysBtn[1].backgroundColor = mediumGreen
                    weekDaysBtn[1].tintColor = mediumGreen
                    weekDaysBtn[1].setTitleColor(.white, for: .normal)
                }else if item == "Mo" {
                    weekDaysBtn[2].backgroundColor = mediumGreen
                    weekDaysBtn[2].tintColor = mediumGreen
                    weekDaysBtn[2].setTitleColor(.white, for: .normal)
                }else if item == "Tu" {
                    weekDaysBtn[3].backgroundColor = mediumGreen
                    weekDaysBtn[3].tintColor = mediumGreen
                    weekDaysBtn[3].setTitleColor(.white, for: .normal)
                }else if item == "We" {
                    weekDaysBtn[4].backgroundColor = mediumGreen
                    weekDaysBtn[4].tintColor = mediumGreen
                    weekDaysBtn[4].setTitleColor(.white, for: .normal)
                }else if item == "Th" {
                    weekDaysBtn[5].backgroundColor = mediumGreen
                    weekDaysBtn[5].tintColor = mediumGreen
                    weekDaysBtn[5].setTitleColor(.white, for: .normal)
                }else if item == "Fr" {
                    weekDaysBtn[6].backgroundColor = mediumGreen
                    weekDaysBtn[6].tintColor = mediumGreen
                    weekDaysBtn[6].setTitleColor(.white, for: .normal)
                }
            }
        }
        if self.userData.rates.count > 0 {
            self.hourlyLbl.text = "$\(userData.rates[0])"
            self.oneToFiveLbl.text = "$\(userData.rates[1])"
            self.sixToFifteenLbl.text = "$\(userData.rates[2])"
            self.sixteenPlusLbl.text = "$\(userData.rates[3])"
        }
        if self.userData.skills.count > 0 {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
        }
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    private func openMaps() {
        let latitude: CLLocationDegrees = Double(userData.latitude)
        let longitude: CLLocationDegrees = Double(userData.longitude)
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Gardener Work"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = CLLocationCoordinate2D(latitude: self.userData.longitude, longitude: self.userData.latitude)
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "\(self.userData.state)"
        annotation.subtitle = "\(self.userData.city), \(self.userData.state) \(self.userData.country)"
        mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
}
extension ProfileDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userData.skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SkillsCollectionViewCell
        guard indexPath.row < self.userData.skills.count else {return cell}
        let instance = self.userData.skills[indexPath.row]
        cell.itemLbl.text = instance
        cell.itemImage.image = UIImage(named: instance)
        return cell
    }
    
}
extension ProfileDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = collectionView.frame.width / 2 - 1
           return CGSize(width: width, height: 30)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 1.0
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1.0
       }
}
