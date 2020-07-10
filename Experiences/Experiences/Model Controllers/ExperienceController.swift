//
//  ExperienceController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import UIKit

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(name: String, image: UIImage?, audioURL: URL?, videoURL: URL?, longitude: Double, latitude: Double) {
        let newExperience = Experience(name: name, image: image, audioURL: audioURL, videoURL: videoURL, longitude: longitude, latitude: latitude)
        experiences.append(newExperience)
    }
}
