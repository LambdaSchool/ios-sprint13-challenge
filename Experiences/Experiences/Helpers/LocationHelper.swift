//
//  LocationHelper.swift
//  Experiences
//
//  Created by Michael Stoffer on 10/3/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
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
