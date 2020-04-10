//
//  MapViewController+CLLocationManager.swift
//  UX
//
//  Created by Nick Nguyen on 4/10/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .denied:
         break
            default:
                locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
       
        print("locations = \(locValue.latitude) \(locValue.longitude)")
            locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    private func checkLocationAuthorization() {
           
             switch CLLocationManager.authorizationStatus() {
                 case .authorizedWhenInUse:   locationManager.startUpdatingLocation()
                     break
                 case .denied:   locationManager.requestWhenInUseAuthorization()
              
                     break
                 case .notDetermined:
                     break
                 case .restricted:
                     // Show an alert letting them know what's up
                     break
                 case .authorizedAlways:

                     self.locationManager.startUpdatingLocation()
                 default:
                     break
             }
         }
      
      
}
