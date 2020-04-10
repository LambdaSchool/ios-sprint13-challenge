//
//  ExperienceController.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
// MARK: Properties
    var experiences: [Experience] = []

// MARK: Methods
    func add (newExperience: Experience) {
        experiences.append(newExperience)
    }
    
    func update(exerience: Experience, title: String, coordinate: CLLocationCoordinate2D) {
        
    }
}
