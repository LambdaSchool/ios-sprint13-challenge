//
//  Location.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    
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
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        requestLocationAuthorization()
        
        group = DispatchGroup()
        
        group?.enter()
        
        locationManager.requestLocation()
        
        
        group?.notify(queue: .main) {
            let coordinate = self.locationManager.location?.coordinate
            
            self.group = nil
            completion(coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        group?.leave()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    var group: DispatchGroup?
    
    private let locationManager = CLLocationManager()
}
