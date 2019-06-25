//
//  ViewController.swift
//  TaxiApp
//
//  Created by Loay on 6/16/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit

class HomeViewController: UIViewController {

// Variables and Constants
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var requestRideButton: RoundedShadowButton!
    
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    @IBOutlet weak var startTripButton: RoundedShadowButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var destinationField: UITextField!
    
    var delegate: CenterViewControllerDelegate?
    let locationManager = CLLocationManager()
    let zoom: Float = 15
    var startLocation: CLLocationCoordinate2D?
    
    var requestDriver = false
    
    var carServicesTitle = [String]()
    var carServicesDesc = [String]()
    
    var alert = UIAlertController()
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocatoinServices()
        setupSearchBar()
        loadCarServicesIntoArr()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        destinationField.inputView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Fixing iphone xr bug
        headerView.gredientView()
    }
    
    @IBAction func RequestRide(_ sender: Any) {
        
        if !requestDriver{
            requestRideButton.animateButton(true, "Finding Drivers..")
        } else {
            requestRideButton.animateButton(false, "Let's Go")
            clearDestinationMarker()
        }
        requestDriver = !requestDriver
    }
    
    @IBAction func menuButton(_ sender: Any) {
        
        delegate?.toogleLeftPanel()
    }
    
    @IBAction func centerLocationButton(_ sender: Any) {
        
        centerMapToLocation()
    }
    
    @IBAction func chooseCarType(_ sender: Any) {
        
        let carServicesActionList = ActionSheet<CarTypeTableViewCell>(tHeigh: 300, tCellHeight: 65, a1: carServicesTitle, a2: carServicesDesc)

        self.view.addSubview(carServicesActionList)
    }
    
    @IBAction func destinationFieldAction(_ sender: Any) {}
    
    @IBAction func logoutAction(_ sender: Any) {
        
        let alertCont = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            // Logout session
            self.logoutfromEmail()
            self.logoutFromFacebook()
            self.delegate?.removeLeftSidePaneFromParentView()
            AppDelegate.containerVC.loadThisScreen(screen: .loginVC)
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in }
        alertCont.addAction(confirmAction)
        alertCont.addAction(cancelAction)
        present(alertCont, animated: true, completion: nil)
    }
    
    // First Layer to use navigation in user phone
    func checkLocatoinServices(){
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }else{
            
            alert.showAlert(title: "Location Services", msg: "Please Turn on Location services from your phone to be able to use our app", action: "Ok", vc: self)
        }
    }
    
    func centerMapToLocation() {
    
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
        let lng = self.mapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: zoom)
        self.mapView.animate(to: camera)
    }
    
    func setDestinationTextField(result: GMSAutocompletePrediction) {
        
        destinationField.text = result.attributedPrimaryText.string
        createDestinationMarker(result: result)
    }
    
    func resetDestinationField() {
        
        clearDestinationMarker()
    }
    
    func createDestinationMarker(result: GMSAutocompletePrediction) {
        mapView.clear()
        let placeClient = GMSPlacesClient()
        placeClient.lookUpPlaceID(result.placeID) { (place, error) -> Void in
            
            if let place = place {
                
                let dest = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                let marker = GMSMarker(position: dest)
                marker.title = "Destination"
                marker.icon = GMSMarker.markerImage(with: .black)
                marker.map = self.mapView
                let path = GMSMutablePath()
                path.add(self.startLocation!)
                path.add(dest)
                let bounds = GMSCoordinateBounds(path: path)
                self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
            }
        }
    }
    
    func clearDestinationMarker() {
        
        destinationField.text = ""
        mapView.clear()
        centerMapToLocation()
    }
    
    func logoutfromEmail() {
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    func logoutFromFacebook() {
        
        if FBSDKAccessToken.current() != nil {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
    }
    
    func loadCarServicesIntoArr() {
        
        carServicesTitle = ["Simple", "Simple+", "White Taxi"]
        carServicesDesc = ["Cheap and affordable", "Classy but a little bit expensive", "If you prefer ordinary life"]
    }
    
}// End Class

// Extensions

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else { return }

        locationManager.startUpdatingLocation()
    
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: zoom, bearing: 0, viewingAngle: 0)
        startLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }
}

extension HomeViewController {
    
    func setupSearchBar() {
        
        let textViewRecognizer = UITapGestureRecognizer()
        textViewRecognizer.addTarget(self, action: #selector(showSearchBar(_:)))
        destinationField.addGestureRecognizer(textViewRecognizer)
    }
    
    @objc func showSearchBar (_ sender: Any) {
        
        clearDestinationMarker()
        // Display the autocomplete view controller.
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        let autocompleteViewController = main.instantiateViewController(withIdentifier: "autoSearchVC") as? AutoCompleteSearchViewController
        present(autocompleteViewController!, animated: true, completion: nil)
    }
}


