//
//  MapViewController.swift
//  ExperiencesSprint
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)

var masterExperienceController = ExperienceController()

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addExperienceButton: UIButton!
    
    let locationManager = CLLocationManager()
    var experienceController: ExperienceController?
    
    // MARK: - Actions
    
    @IBAction func addExperienceTapped(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        guard let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude else { return }
        let coordinates = CLLocationCoordinate2DMake(lat, long)
        currentLocation = coordinates
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.addAnnotations(masterExperienceController.experiences)
    }
}

// MARK: - Extensions

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            print("could not make annotation as experience")
            return nil
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: experience) as? MKMarkerAnnotationView else {
            print("could not make annotationView in mapVC")
            return nil
        }
        print(annotationView)
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let center = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.069, longitudeDelta: 0.069)
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}
