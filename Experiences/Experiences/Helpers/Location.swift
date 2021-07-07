//
//  Location.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
    var group: DispatchGroup?
    private let locationManager = CLLocationManager()
    static let shared = Location()
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocationAuthorization()
    }
    
    func requestLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        requestLocationAuthorization()
        group = DispatchGroup()
        group?.enter()
        locationManager.requestLocation()
        group?.notify(queue: .main) {
            let coordinate = self.locationManager.location?.coordinate
            self.group = nil
            completion(coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        group?.leave()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
}
