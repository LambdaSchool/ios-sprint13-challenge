//
//  Experience Controller.swift
//  Experiences-Sprint-Challenge
//
//  Created by Jonalynn Masters on 1/17/20.
//  Copyright © 2020 Jonalynn Masters. All rights reserved.
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
    
    func update(exerience: Experience, title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
    }
}
