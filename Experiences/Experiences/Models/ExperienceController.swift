//
//  ExperienceController.swift
//  Experiences
//
//  Created by Chris Dobek on 6/7/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import MapKit

class ExperienceController {
    
    static var experiences = [Experience]()
    
    func loadExperience() {
        
    }
    
    func savedExperience( _ experience: Experience, completion: () -> Void) {
        ExperienceController.experiences.append(experience)
        completion()
    }
    
}
