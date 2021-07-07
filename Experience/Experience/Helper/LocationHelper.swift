//
//  LocationHelper.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//
import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static var shared: LocationHelper = LocationHelper()
    
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
    override init() {
        super.init()
        
        requestAuthorization()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func startLocationTracking() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
}

