//
//  ExperienceController.swift
//  Experiences
//
//  Created by Sean Hendrix on 1/18/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL, audioURL: URL, imageData: Data) {
        
        let experience = Experience(title: title, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        
        experiences.append(experience)
    }
    
    
    
    var experiences: [Experience] = []
}
