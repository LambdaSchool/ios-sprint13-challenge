//
//  LocationController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
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
