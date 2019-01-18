//
//  LocationManagerHelper.swift
//  Experiences
//
//  Created by Sean Hendrix on 1/18/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerHelper: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
}
