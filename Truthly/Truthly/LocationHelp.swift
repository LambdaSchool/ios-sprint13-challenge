//
//  LocationHelp.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationHelper: NSObject {

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
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         group?.leave()
     }

     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("Failed getting location \(error)")
     }
}
