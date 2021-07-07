//
//  LocationHelper.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreLocation
class LocationHelper: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            longitude = Double(location.coordinate.longitude)
            latitude = Double(location.coordinate.latitude)
            print("longitude: \(longitude)" + "latitude: \(latitude)")
        }
    }
    
    

    
}
