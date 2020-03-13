//
//  LocationController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import MapKit


// Protocol for Updating Locations
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
    
    // Get Request Location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}


// Delegate Extension
extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error updating location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.update(locations: locations)
    }
}
