//
//  ExperienceController.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    func createExperience(with title: String, audioURL: URL, videoURL: URL, imageURL: URL,  geotag: CLLocationCoordinate2D? = nil, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let newExperience = Experience(title: title, audioURL: audioURL, videoURL: videoURL, imageURL: imageURL, geotag: geotag, timestamp: Date())
        
        Experiences.shared.addNewExperience(experience: newExperience)
        
    }
    
}
