//
//  ExperienceController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(title: String, image: Data? = nil, audioRecordingURL: URL? = nil, videoRecordingURL: URL? = nil, longitude: Double, latitude: Double) {
        let experience = Experience(experiencetitle: title, posterImage: image, videoURL: videoRecordingURL, audioRecordingURL: audioRecordingURL, longitude: longitude, latitude: latitude)
        
        experiences.append(experience)
    }
    
}
