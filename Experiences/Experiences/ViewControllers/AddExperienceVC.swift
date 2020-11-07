//
//  AddExperienceVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

protocol AddExpDelegate: AnyObject {
    func addExperience()
}

class AddExperienceVC: UIViewController {

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var audioButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var imageButton: UIButton!
    @IBOutlet private var addressTextField: UITextField!
    @IBOutlet private var mapView: MKMapView!
    
    var coordinate: CLLocationCoordinate2D?
    fileprivate let locationManager = CLLocationManager()
    var span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    var userLocation: CLLocationCoordinate2D?
    weak var delegate: AddExpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addAudio(_ sender: UIButton) {
    }
    
    @IBAction func addVideo(_ sender: UIButton) {
    }
    
    @IBAction func addImage(_ sender: UIButton) {
    }
    
    @IBAction func useLocation(_ sender: UIButton) {
        guard let userLocation = userLocation else { return }
        coordinate = userLocation
        let experience = Experience(title: titleTextField.text, coordinate: userLocation)
        self.mapView.addAnnotation(experience)
    }
    
    @IBAction func useAddress(_ sender: UIButton) {
        guard let address = addressTextField.text else { return }
        reverseGeocode(address: address) { placemark in
            if let latitude = placemark.location?.coordinate.latitude,
               let longitude = placemark.location?.coordinate.longitude {
                self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                guard let coordinate = self.coordinate else { return }
                let experience = Experience(title: self.titleTextField.text, coordinate: coordinate)
                self.mapView.addAnnotation(experience)
            } else {
                let alert = UIAlertController(title: "Error", message: "Please enter a valid address.", preferredStyle: .alert)
                let button = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func saveExperience(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let coordinate = coordinate else { return }
        let experience = Experience(title: title, coordinate: coordinate)
        ExperienceController.shared.experiences.append(experience)
        delegate?.addExperience()
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    private func reverseGeocode(address: String, completion: @escaping (CLPlacemark) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemarks = placemarks,
                  let placemark = placemarks.first else {
                return
            }
            completion(placemark)
        }
    }
    
}

extension AddExperienceVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        userLocation = currentLocation
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
