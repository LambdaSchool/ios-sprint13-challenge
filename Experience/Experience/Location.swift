//
//  Location.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
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
        //locationManager.requestLocation()
        return locationManager.location
    }
    
    // MARK: - CLLocationManagerDelegate
    
}
