//
//  ExperienceController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    var experiences: [Experience] = []
    
    
    func addNewExperience(name: String, imageData: Data?, audioData: Data?, videoData: Data?, location: CLLocation) {
        
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let experience = Experience(name: name, imageData: imageData ?? Data(), audioData: audioData ?? Data(), videoData: videoData ?? Data(), coordinate: currentLocation)
        
        experiences.append(experience)
    }
}
