//
//  LocationHelper.swift
//  LambdaTimeline
//
//  Created by Linh Bouniol on 10/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    // so we can share this class around so we dont need to pass around reference
    static var shared: LocationHelper = LocationHelper()
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    override init() {
        super.init()
        
        requestAuthorization()  // the first time the locationHelper is made, it requests authorization
    }
    
    // call once at begining
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // call start and stop when in the screen where we want the location
    
    func startLocationTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    // call this to grab the currentLocation
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // CLLocation is an array b/c there are many locations as we're moving
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // dont need anything here b/c we dont care when the location changes
    }
}
