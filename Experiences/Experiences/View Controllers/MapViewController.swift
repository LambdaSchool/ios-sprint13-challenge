//
//  MapViewController.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - PROPERTIES
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    // MARK: - OUTLETS
    
    @IBOutlet var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MapView")
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if let userLocation = mapView.userLocation.location?.coordinate {
            mapView.setCenter(userLocation, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addAnnotation()
    }
    
    // MARK: - Methods
    func addAnnotation() {
        let myPin = MKPointAnnotation()
        if let myCoordinate = experienceController.experience?.coordinate {
            myPin.coordinate = myCoordinate
        }
        if let annotationText = experienceController.experience?.experienceTitle {
            myPin.title = annotationText
        }
        mapView.addAnnotation(myPin)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            guard let newExperienceVC = segue.destination as? AddExperienceViewController else { return }
            newExperienceVC.experienceController = experienceController
            newExperienceVC.coordinate = coordinate
        }
    }
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapView", for: experience) as! MKMarkerAnnotationView
        annotationView.glyphText = experience.experienceTitle
        annotationView.glyphTintColor = .systemBlue
        annotationView.titleVisibility = .visible
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        coordinate = annotation.coordinate
    }
}
