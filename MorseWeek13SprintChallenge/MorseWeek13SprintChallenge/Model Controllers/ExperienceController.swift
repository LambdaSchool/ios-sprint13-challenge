//
//  ExperienceController.swift
//  MorseWeek13SprintChallenge
//
//  Created by morse on 1/17/20.
//  Copyright © 2020 morse. All rights reserved.
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
        print(experiences[0].videoURL)
    }
}
