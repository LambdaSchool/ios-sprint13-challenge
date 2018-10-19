//
//  ExperienceController.swift
//  Experiences
//
//  Created by Vuk Radosavljevic on 10/19/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit

class ExperienceController {
    
    static let shared = ExperienceController()
    
    private(set) var experiences = [Experience]()
    
    
    func addExperience(image: UIImage, recordingURL: URL, videoURL: URL) {
        let experience = Experience(image: image, recordingURL: recordingURL, videoURL: videoURL)
        experiences.append(experience)
    }
    
}
