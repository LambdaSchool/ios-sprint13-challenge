//
//  LocationHelper.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//
import CoreLocation
import MapKit
import Foundation

class LocationHelper: NSObject {
    static let shared = LocationHelper()
    
    private let locationManager = CLLocationManager()
    var group: DispatchGroup?
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestUserLocationAuthorization()
    }
    
    func requestUserLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            return
        @unknown default:
            break
        }
    }
    
    func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        requestUserLocationAuthorization()
        
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
        print("failed to get location: \(error.localizedDescription)")
    }
}
