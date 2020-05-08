//
//  ExperienceController.swift
//  Experiences
//
//  Created by Karen Rodriguez on 5/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController: NSObject {

    let locationManager = CLLocationManager()
    var experiences: [Experience] = []
    var currentLocation: CLLocationCoordinate2D?

    func createExperience(title: String, content: String, videoURL: String?, imageData: Data?, audioURL: String?, geoTag: CLLocationCoordinate2D) {

        let newExperience = Experience(expTitle: title, content: content, geoTag: geoTag, videoURL: videoURL, imageData: imageData, audioURL: audioURL)
        experiences.append(newExperience)
    }

    func locationPermission() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension ExperienceController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location Manager failed: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = locValue
    }

}
