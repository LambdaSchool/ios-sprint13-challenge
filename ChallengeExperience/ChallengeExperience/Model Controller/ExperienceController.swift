//
//  ExperienceController.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import AVFoundation
import MapKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(with name: String, imageData: Data, video: URL, audio: URL, location: CLLocationCoordinate2D) {
        let experience = Experience(name: name, imageData: imageData, video: video, audio: audio, location: location)
        
        experiences.append(experience)
    }
}
