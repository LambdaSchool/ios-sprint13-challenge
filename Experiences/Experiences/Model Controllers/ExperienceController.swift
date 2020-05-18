//
//  ExperienceController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation

class ExperienceController {
    
    var experiences: [Experience] = []
    
    @discardableResult func createExperience(title: String, latitude: Double, longitude: Double, videoExtension: String, audioExtension: String, photoExtension: String) -> Experience{
        
        let experience = Experience(title: title, latitude: latitude, longitude: longitude, videoExtension: videoExtension, audioExtension: audioExtension, photoExtension: photoExtension)
        experiences.append(experience)
        return experience
    }
    
    func addVideoToExperience(videoExtension: String) {
        guard experiences.first != nil else { return }
        experiences[0].videoExtension = videoExtension
    }
    
}
