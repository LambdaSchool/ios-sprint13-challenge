//
//  ExperienceController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import UIKit

class ExperienceController {
    
    var experience: Experience?
    
    func createExperience(geoTag: GeoTag,
                          description: String,
                          audioComment: URL? = nil,
                          videoComment: URL? = nil,
                          photo: UIImage? = nil) {
        let newExperience = Experience(description: description,
                                       geoTag: geoTag,
                                       audioComment: audioComment,
                                       videoComment: videoComment,
                                       photo: photo)
        self.experience = newExperience
    }
    
}
