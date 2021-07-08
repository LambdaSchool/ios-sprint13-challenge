//
//  LocationManager.swift
//  LambdaTimeline
//
//  Created by scott harris on 4/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation


class Location: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestAuthorization()
        
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        if let currentLocation = currentLocation {
            return currentLocation
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location is: \(locations)")
        self.currentLocation = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
}
