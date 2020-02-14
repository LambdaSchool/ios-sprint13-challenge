//
//  LocationController.swift
//  Experiences
//
//  Created by Rick Wolter on 2/14/20.
//  Copyright © 2020 Devshop7. All rights reserved.
//


import MapKit

protocol LocationControllerDelegate {
    func update(locations: [CLLocation])
}

class LocationController: NSObject {
    let locationManager: CLLocationManager
    var delegate: LocationControllerDelegate?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error updating location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.update(locations: locations)
    }
}
