//
//  MapViewController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: Properties
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10_000
    var experienceController = ExperienceController()
    var coordinates = CLLocationCoordinate2D()
    var experienceTitle = ""

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        mapView.delegate = self

    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Zoom in to user's are by regionInMeters
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //Whatever latitude and longitude you give it, that's where it will place a pin
    @objc func addAnnotation() {
        
        
        let newLocationAnnotation = MKPointAnnotation()
        newLocationAnnotation.title = experienceTitle
        newLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        mapView.addAnnotation(newLocationAnnotation)
        print("Added Annotation of new experience to map")
    }
    
    // Checking if location services are even permited in the entire device
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // TODO: Show alert letting the user know we need permission
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse :
            mapView.showsUserLocation = true // Display current location
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation() // Updates location as it moves
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // asking fro permission
        case .restricted:
            // TODO: Show alert letting know whats up
            break
        case .denied:
            // TODO: Show alert instructing them how to turn on permission
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        coordinates.latitude = latitude
        coordinates.longitude = longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    

    
    
    
    // MARK: Listen for Notifications with Observers!
    

//    func addObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotation), name: .newLocation, object: <#T##Any?#>)
////        experienceTitle = objectTitele ^^
//    }
//    
    
    
    
//    // Changing background color
//    func addObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(changeToRed), name: .newLocation, object: )
//}
//        NotificationCenter.default.addObserver(self, selector: #selector(changeToBlue), name: .blue, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(changeToGreen), name: .green, object: nil)
//    }
//

    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateExperienceSegue" {
            
            if let addExperienceVC = segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = self.experienceController
                addExperienceVC.coordinates = self.coordinates
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // This func runs every time the user moves (re-locates)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    // Runs everytime the authirization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }

}
