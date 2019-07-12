//
//  ExperienceController.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(title: String, audio: URL, video: URL, image: UIImage) {
        let newExperience = Experience(audio: audio, video: video, image: image, title: title)
        
//        experiences.append(newExperience)
    }
    
    //save an experience
    //append to experiences
    
}
