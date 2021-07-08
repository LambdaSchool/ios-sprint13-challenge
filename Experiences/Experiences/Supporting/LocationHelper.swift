//
//  LocationHelper.swift
//  Experiences
//
//  Created by Victor  on 7/12/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    lazy var locationManager: CLLocationManager = {
        var result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    // MARK: - Public
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation() -> CLLocation? {
        return locationManager.location
    }
}

