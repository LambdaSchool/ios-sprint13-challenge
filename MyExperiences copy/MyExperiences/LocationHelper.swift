//
//  LocationHelper.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {

    
    static let shared = LocationHelper()
    
    private let locationManager = CLLocationManager()
    var group: DispatchGroup?

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
        print("Failed getting location \(error)")
    }

}
