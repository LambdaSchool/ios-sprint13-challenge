//
//  LocationManagerDelegate.swift
//  Experiences
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerDelegate:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            
            switch status {
            case .authorizedWhenInUse:
                locationManager.requestLocation()
            default:
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didUpdateLocations locations: [CLLocation]) {
            
            mapView.showsUserLocation = true
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                NSLog("Error with location manager: \(error)")
        }
    
}
