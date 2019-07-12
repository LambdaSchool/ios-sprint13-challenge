//
//  MapViewController.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var didSetPosition = false

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        startLocationServices()
    }
    
    private func startLocationServices() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            activateLocationServices()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    private func activateLocationServices() {
        locationManager?.startUpdatingLocation()
    }
    
    private func centerMapOnLocation() {
        
        if let currentLocation = currentLocation, !didSetPosition {
            
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                                longitude: currentLocation.coordinate.longitude)
            
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            self.mapView.setRegion(region, animated: false)
            
            didSetPosition = true
        } else {
            return
        }
        
        
    }
    
    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        print("Added Experience")
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            currentLocation = location
            centerMapOnLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager?.startUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
