//
//  MapExperiencesViewController.swift
//  Experiences
//
//  Created by Jordan Christensen on 11/1/19.
//  Copyright © 2019 Mazjap Co. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapExperiencesViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotations = mapView.annotations.compactMap({ $0 as? Experience })
        mapView.addAnnotations(annotations as! [MKAnnotation])
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied:
            let alert = UIAlertController(title: "Location Permissions Disabled", message: "It looks like location permissions are disabled. Please enable them in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            mapView.showsUserLocation = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "Location is Restricted", message: "Please get access from your administrator.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            mapView.showsUserLocation = false
        @unknown default:
            fatalError("Location services/permission status unknown. Please update to latest version of the app")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let experienceVC = segue.destination as? AddExperienceViewController else { return }
        if segue.identifier == "ModelAddExperienceSegue" {
            experienceVC.delegate = self
        }
    }
}

extension MapExperiencesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("I'm running!")
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
}

extension MapExperiencesViewController: ExperienceDelegate {
    func newExperienceCreated(_ experience: Experience) {
        guard let location = locationManager.location else { return }
        experience.geotag = location.coordinate
    }
}
