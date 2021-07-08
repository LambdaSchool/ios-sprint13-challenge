//
//  LocationHelper.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper {
    
    init(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    let locationManager = CLLocationManager()
    
    func fetchUsersLocation() -> CLLocationCoordinate2D? {
        
        return locationManager.location?.coordinate
        
    }
}
