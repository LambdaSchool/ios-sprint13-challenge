//
//  ExperienceController.swift
//  Experiences
//
//  Created by John Kouris on 1/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class ExperienceController {
    
    var experiences = [Experience]()
    
    func createExperience(with title: String, latitude: Double, longitude: Double, image: UIImage?, audioRecording: URL?, videoRecording: URL?) {
        let userExperience = Experience(title: title, latitude: latitude, longitude: longitude, image: image, audioRecording: audioRecording, videoRecording: videoRecording)
        experiences.append(userExperience)
    }
    
}
