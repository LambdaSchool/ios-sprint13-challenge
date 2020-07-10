//
//  LocationController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationController: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center,
                                            span: MKCoordinateSpan(
                                                latitudeDelta: 0.01,
                                                longitudeDelta: 0.01))
        }
    }
    
    func getLocation() -> CLLocation {
        if let location = locationManager.location {
            return location
        }
        
        return CLLocation(latitude: 0, longitude: 0)
    }

}
