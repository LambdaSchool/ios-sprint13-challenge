//
//  ExperienceController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class ExperienceController {
    var experiences: [Experience] = []
    
    func add (newExperience: Experience) {
        experiences.append(newExperience)
    }
}
