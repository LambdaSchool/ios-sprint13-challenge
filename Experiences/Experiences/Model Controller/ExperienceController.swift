//
//  ExperienceController.swift
//  Experiences
//
//  Created by David Wright on 5/18/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    @discardableResult
    func createExperience(title: String, imageURL: URL? = nil, audioURL: URL? = nil, videoURL: URL? = nil) -> Experience {
        
        let experience = Experience(title: title, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL)
        
        experiences.append(experience)
        
        return experience
    }
    
    
}
