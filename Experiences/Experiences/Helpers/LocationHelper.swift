//
//  LocationHelper.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHelper()
    private override init () {}
    
    
    private var closure: ((Bool) -> Void)?
    private let manager = CLLocationManager()
    
    func requestAccess(completion: @escaping (Bool) -> Void = { _ in }) {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            closure = completion
            manager.requestWhenInUseAuthorization()
        case .restricted:
            completion(false)
        case .denied:
            completion(false)
        case .authorizedAlways:
            completion(true)
        case .authorizedWhenInUse:
            completion(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let completion = closure {
            switch status {
            case .notDetermined:
                completion(false)
            case .restricted:
                completion(false)
            case .denied:
                completion(false)
            case .authorizedAlways:
                completion(true)
            case .authorizedWhenInUse:
                completion(true)
            }
        }
    }
    
    var currentLoction: CLLocation? {
        if CLLocationManager.locationServicesEnabled() {
            return manager.location
        } else {
            return nil
        }
    }
    
}
