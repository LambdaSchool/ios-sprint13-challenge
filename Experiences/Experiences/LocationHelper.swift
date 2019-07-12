//
//  LocationManager.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static var shared: LocationHelper = LocationHelper()
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.desiredAccuracy = kCLLocationAccuracyKilometer
        result.pausesLocationUpdatesAutomatically = true
        result.delegate = self
        return result
    }()
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
    
    override init() {
        super.init()
        requestAuthorization()
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        startTrackingLocation()
    }
    
    func startTrackingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let _: CLLocationCoordinate2D = manager.location!.coordinate
        stopTrackingLocation()
    }
    
}
