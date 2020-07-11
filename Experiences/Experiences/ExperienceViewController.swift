//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperienceViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet var addExperienceButton: UIButton!
    
    var experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addExperienceButton.layer.cornerRadius = 8
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        currentLocation = locationManager.location?.coordinate
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.addAnnotations(experienceController.experiences)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddExperiences" {
            let destinationVC = segue.destination as? AddExperienceViewController
            destinationVC?.experienceController = self.experienceController
            destinationVC?.currentLocation = currentLocation
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        <#code#>
    }
}


extension ExperienceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status != CLAuthorizationStatus.authorizedAlways || status != CLAuthorizationStatus.authorizedWhenInUse else { return }
        
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error: Did fail with error \(error)")
    }
}
