//
//  ExperienceController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import MapKit

class ExperienceController {
    private (set) var experience: [Experience] = []
    
    var currentLocation: CLLocationCoordinate2D?
    
    func addNewExperience(newExperience: Experience) {
        experience.append(newExperience)
    }
}
