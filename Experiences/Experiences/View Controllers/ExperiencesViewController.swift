//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Bronson Mullens on 9/11/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    var annotations: [MKAnnotation] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnnotations()
    }
    
    // MARK: - Methods
    
    private func setupLocation() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways:
            beginLocationUpdates(locationManager)
        case .authorizedWhenInUse:
            beginLocationUpdates(locationManager)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            NSLog("Unknown status code for CLLocationManager")
        }
    }
    
    private func setupAnnotations() {
        let experiences = experienceController.experiences
        for experience in experiences {
            let annotation = MKPointAnnotation()
            annotation.title = experience.title
            annotation.coordinate = experience.coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    private func moveToLastLocation(with coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func beginLocationUpdates(_: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reuseIdentifier = "NewExperienceSegue"
        
        if segue.identifier == reuseIdentifier {
            if let newExperienceVC = segue.destination as? NewExperienceViewController {
                newExperienceVC.experienceController = experienceController
                newExperienceVC.coordinates = currentLocation
            }
        }
    }
    
}

extension ExperiencesViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier: String = "ExperienceView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        annotationView?.canShowCallout = true
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            beginLocationUpdates(locationManager)
        } else {
            NSLog("Invalid status code for locationManager")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first else { return }
        
        if currentLocation == nil {
            moveToLastLocation(with: lastLocation.coordinate)
            setupAnnotations()
        }
        currentLocation = lastLocation.coordinate
    }
    
}
