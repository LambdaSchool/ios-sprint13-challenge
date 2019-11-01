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

class MapExperiencesViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var mapViewShouldUpdate = false
    
    var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        print(mapView.annotations.count)
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotations = mapView.annotations.compactMap({ $0 as? Experience })
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapViewShouldUpdate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 100_000, longitudinalMeters: 100_000)
            mapView.setRegion(region, animated: true)
            mapViewShouldUpdate = false
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            let alert = UIAlertController(title: "Location Permissions Disabled", message: "It looks like location permissions are disabled. Please enable them in settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            let alert = UIAlertController(title: "Location is Restricted", message: "Please get access from your administrator.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1_000_000, longitudinalMeters: 1_000_000)
        mapView.setRegion(region, animated: true)
        userLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
}

extension MapExperiencesViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { fatalError("It's an experience") }
        
        annotationView.tintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
}

extension MapExperiencesViewController: ExperienceDelegate {
    func newExperience(name: String, image: UIImage) {
        let experience = Experience(name: name, image: image, coordinate: userLocation)
        mapView.addAnnotation(experience as MKAnnotation)
        mapViewShouldUpdate = true
        print(mapView.annotations.count)
    }
}
