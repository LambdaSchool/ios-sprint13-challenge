//
//  Location.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
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
        
        let coordinate = locationManager.location?.coordinate
        print("Coordinate: \(coordinate)")
        completion(coordinate)
        
       group?.notify(queue: .main) {
            let coordinate = self.locationManager.location?.coordinate
            
            self.group = nil
            completion(coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    }
    func setCoordinate(coordinate: CLLocationCoordinate2D) {
        coordinateFound = coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    var group: DispatchGroup?
    
    private let locationManager = CLLocationManager()
    
    var coordinateFound: CLLocationCoordinate2D?
    
}

extension Notification.Name {
    static let coord = Notification.Name("setCoord")
    
}
