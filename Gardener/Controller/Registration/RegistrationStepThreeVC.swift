//
//  RegistrationStepThreeVC.swift
//  Gardener
//
//  Created by Ehtisham Khalid on 12.05.21.
//

import UIKit
import MapKit
import Firebase

class RegistrationStepThreeVC: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var annotationAddress: UILabel!
    @IBOutlet weak var annotationTitle: UILabel!
    @IBOutlet weak var CustomAnnotationView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!

    
    //MARK:- Variables
    lazy var searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    lazy var searchResults = [MKLocalSearchCompletion]()
    lazy var locationDictionary = LocationModel()
    lazy var user = UserModel()
    private var ref: DatabaseReference!
    private var progressIndicator = ProgressHUD(text: "Please wait...")
    
    //MARK:- View Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK:- Actions
    @objc func annotationBtnTapped(sender:UITapGestureRecognizer){
        updateUser()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private functions
    private func updateUser(){
        self.view.addSubview(progressIndicator)
        user.city = locationDictionary.city
        user.state = locationDictionary.state
        user.country = locationDictionary.country
        user.postalCode = locationDictionary.zipcode
        user.address = locationDictionary.titleString
        
        let dict:[String:Any] = [
            "city":user.city,
            "state":user.state,
            "country":user.country,
            "postalCode":user.postalCode,
            "address":user.address
        ]
        
        self.ref.child("USER").child(self.user.userId).updateChildValues(dict) { (err, dbRef) in
            self.progressIndicator.removeFromSuperview()
            if err == nil {
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let vc = SB.instantiateViewController(identifier: "RegistrationStepFourVC") as! RegistrationStepFourVC
                vc.user = self.user
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }else{
                showAlert(type: .error, Alert: "Error", details: "\(String(describing: err?.localizedDescription))", controller: self, status: false)
            }
        }
    }
    
    private func setupViews() {
        ref = Database.database().reference()
        let tap = UITapGestureRecognizer(target: self, action: #selector(annotationBtnTapped(sender:)))
        self.CustomAnnotationView.isUserInteractionEnabled = true
        self.CustomAnnotationView.addGestureRecognizer(tap)
        
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor(hexString: "#424242")
        searchCompleter.delegate = self
        
        locationTableView.addShadow()
        mapView.showsUserLocation = true
        
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    //TODO:- Search Bar functionality
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.CustomAnnotationView.isHidden = true
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchCompleter.queryFragment = searchText
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            if response == nil{
                print("ERROR")
            }else{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location)
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            mapView.mapType = MKMapType.standard
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapView.setRegion(region, animated: true)
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            self.locationDictionary.latitude = location.coordinate.latitude
            self.locationDictionary.longtitude = location.coordinate.longitude
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    
                    if let streetName = placeMark.subLocality {
                        print(streetName)
                        self.locationDictionary.street = streetName
                    }
                    
                    if let name = placeMark.name {
                        print(name)
                        self.locationDictionary.titleString = name
                    }
                    
                    // City
                    if let city = placeMark.locality {
                        print(city)
                        self.locationDictionary.city = city
                    }
                    // Zip code
                    if let zip = placeMark.postalCode {
                        print(zip)
                        self.locationDictionary.zipcode = zip
                    }
                    // Country
                    if let country = placeMark.country {                        print(country)
                        self.locationDictionary.country = country
                    }
                    if let state = placeMark.administrativeArea {
                        self.locationDictionary.state = state
                    }
                    if let countryCode = placeMark.isoCountryCode {
                        self.locationDictionary.isoCountryCode = countryCode
                    }
                    self.locationManager.delegate = nil
                    let address = "\(self.locationDictionary.titleString) \(self.locationDictionary.zipcode) \(self.locationDictionary.state)"
                    self.searchBar.text = address
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = locValue
                    annotation.title = self.locationDictionary.city
                    self.annotationTitle.text = self.locationDictionary.city
                    annotation.subtitle = self.locationDictionary.titleString
                    self.annotationAddress.text = address
                    self.mapView.addAnnotation(annotation)
                    //                                                    self.UpdateProfile()
                    return
            })
        }
    }
}
extension RegistrationStepThreeVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        self.locationTableView.isHidden = false
        locationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.locationTableView.isHidden = true
        // handle error
    }
    
}
extension RegistrationStepThreeVC: UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            self.locationDictionary.titleString = (response?.mapItems[0].placemark.title ?? "")
            self.locationDictionary.country = (response?.mapItems[0].placemark.country ?? "" )
            self.locationDictionary.city =  (response?.mapItems[0].placemark.locality ?? " " )
            self.locationDictionary.street = (response?.mapItems[0].placemark.subLocality ?? " " )
            self.locationDictionary.state = (response?.mapItems[0].placemark.administrativeArea ?? "" )
            self.locationDictionary.zipcode = (response?.mapItems.last!.placemark.postalCode ?? "")
            self.locationDictionary.isoCountryCode = (response?.mapItems.last!.placemark.isoCountryCode ?? "")
            self.locationDictionary.latitude = coordinate!.latitude
            self.locationDictionary.longtitude = coordinate!.longitude
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = UIActivityIndicatorView.Style.medium
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            activityIndicator.stopAnimating()
            if response == nil{
                print("ERROR")
            }else{
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
               
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                
                annotation.title = response?.mapItems[0].name
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                let address = "\(self.locationDictionary.titleString) \(self.locationDictionary.zipcode) \(self.locationDictionary.state)"
                annotation.title = self.locationDictionary.city
                self.annotationTitle.text = self.locationDictionary.city
                annotation.subtitle = self.locationDictionary.titleString
                self.annotationAddress.text = address
                self.mapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                
                self.searchBar.text = address
                self.locationTableView.isHidden = true
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.CustomAnnotationView.isHidden = false
    }
    
}
