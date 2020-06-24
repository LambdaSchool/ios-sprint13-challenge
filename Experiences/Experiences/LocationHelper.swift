//
//  LocationHelper.swift
//  Experiences
//
//  Created by Ryan Murphy on 7/12/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
}
