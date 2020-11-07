//
//  MapViewController.swift
//  Experience
//
//  Created by Bohdan Tkachenko on 11/7/20.
//

import UIKit
import MapKit

enum ReuseIdentifier {
    static let experienceAnnotation = "ExperienceView"
}

class MapViewController: UIViewController {
    
    // MARK:  IBOutlets
    @IBOutlet var mapView: MKMapView!
    
    // MARK:  Properties
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    let experienceController = ExperienceController.shared
    var currentLocation: CLLocationCoordinate2D?
    var annotations: [MKAnnotation] = []
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(experienceController.experiences)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
        ])
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: ReuseIdentifier.experienceAnnotation)
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnnotations()
    }
    
    
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
            annotation.title = experience.title as? String
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

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ReuseIdentifier.experienceAnnotation, for: experience) as! MKMarkerAnnotationView
        
        annotationView.canShowCallout = true

        let detailView = EperienceDetailView()
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ReuseIdentifier.experienceAnnotation) as! MKMarkerAnnotationView
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
