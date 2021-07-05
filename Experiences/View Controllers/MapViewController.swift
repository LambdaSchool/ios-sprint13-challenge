//
//  MapViewController.swift
//  Experiences
//
//  Created by Dennis Rudolph on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
   
    @IBOutlet weak var mapView: MKMapView!
    
    var expController = ExpController()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
            
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExpView")
        self.mapView.addAnnotations(expController.experiences)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.mapView.addAnnotations(expController.experiences)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //show alert to set up location services
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            setUsersCoordinates()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func setUsersCoordinates() {
        expController.usersLatitude = locationManager.location?.coordinate.latitude
        expController.usersLongitude = locationManager.location?.coordinate.longitude
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            let destinationVC = segue.destination as? AddViewController
            destinationVC?.expController = expController
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExpView") as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}
