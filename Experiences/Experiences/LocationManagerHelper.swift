//
//  LocationManagerHelper.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
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
