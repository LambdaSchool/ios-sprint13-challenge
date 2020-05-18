//
//  ExperienceController.swift
//  Experiences
//
//  Created by David Wright on 5/18/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController: NSObject {
    
    var experiences: [Experience] = []
    
    private let locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    
    @discardableResult
    func createExperience(title: String, imageURL: URL? = nil, audioURL: URL? = nil, videoURL: URL? = nil) -> Experience {
        
        locationManager.requestLocation()
        location = locationManager.location?.coordinate
        
        let experience = Experience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, geotag: location)
        
        experiences.append(experience)
        
        return experience
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
}

extension ExperienceController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            self.location = location.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
