//
//  MapKitViewController.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapKitViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    var experiences: [Experience] = [Experience(title: "Bruh Bruh, thats lit!", image: UIImage(named: "Drake"), video: nil, audio: nil, coordinate: CLLocationCoordinate2D(latitude: 37.569470, longitude: -122.314700))]

    var coordinate = CLLocationCoordinate2D()
    
    let regionRadius: CLLocationDistance = 4000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        locationManager.delegate = self
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Experience")
        
        NotificationCenter.default.addObserver(forName: .saveTapped, object: nil, queue: nil) { (catchNotification) in
            let exp = catchNotification.userInfo?[experienceSaved]
            if let savedExperience = exp as? Experience {
                self.experiences.append(savedExperience)
                self.mapView.addAnnotation(savedExperience)
                print(savedExperience.expTitle)
                print(savedExperience.image)
            }
        }
        self.mapView.addAnnotations(self.experiences)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        if let coords = mapView.userLocation.location?.coordinate {
            self.coordinate = coords
            let initialLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            centerMapOnLocation(location: initialLocation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    @IBAction func addExpTapped(_ sender: Any) {
        checkLocationAuthorizationStatus()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        if let coords = mapView.userLocation.location?.coordinate {
            self.coordinate = coords
            let initialLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            centerMapOnLocation(location: initialLocation)
        }
        self.performSegue(withIdentifier: "AddExperienceSegue", sender: self)
    }
    
    @IBAction func getLocationTapped(_ sender: Any) {
        checkLocationAuthorizationStatus()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        if let coords = mapView.userLocation.location?.coordinate {
            let initialLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
            centerMapOnLocation(location: initialLocation)
        }
    }
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            if let coords = mapView.userLocation.location?.coordinate {
                mapView.setCenter(coords, animated: true)
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    @objc func addLitExperience(_ notification: Notification) {
        let experience = notification.userInfo?["experience"]
        experiences.append(experience as! Experience)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            guard let newExperienceVC = segue.destination as? NewExperienceViewController else { return }
            newExperienceVC.coordinate = coordinate
        }
    }
}

extension MapKitViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let experience = annotation as? Experience
        
//        guard let experience = annotation as? Experience else {
//            fatalError("Only Experience Objects are currently supported")
//        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Experience", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered map annotation view")
        }
        annotationView.glyphImage = UIImage(systemName: "flame")
        annotationView.glyphTintColor = UIColor.orange
        annotationView.canShowCallout = true
        let detailView = ExperienceDetailView()
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}

extension MapKitViewController: CLLocationManagerDelegate {
    
}
