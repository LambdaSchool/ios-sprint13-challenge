//
//  ExperiencesViewController+LocationManagerDelegate.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation


extension ExperiencesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Location Manager geocoder error: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first,
                let latitude = placemark.location?.coordinate.latitude,
                let longitude = placemark.location?.coordinate.longitude else { return }
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location Manager did failed: \(error)")
        return
    }
}
