//
//  ExperienceController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import MapKit

class ExperienceController {
    static var experiences = [Experience]()
    
    func loadExperience() {
        
    }
    
    func saveExperience(_ experience: Experience, completion: () -> Void) {
        ExperienceController.experiences.append(experience)
        completion()
    }
}
