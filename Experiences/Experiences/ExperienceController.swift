//
//  ExperienceController.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL, audioURL: URL, imageURL: URL) {
        
        let experience = Experience(title: title, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageURL: imageURL)
        
        experiences.append(experience)
    }
    
    
    
    var experiences: [Experience] = []
}
