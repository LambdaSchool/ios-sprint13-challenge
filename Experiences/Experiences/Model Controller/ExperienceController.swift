//
//  ExperienceController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    var experiences: [Experience] = []
    var experience: Experience?
    
    func createExperience(coordinate: CLLocationCoordinate2D, name: String?, image: UIImage?, audio: URL?, video: URL?) {
        let newExperience = Experience(coordinate: coordinate, name: name, image: image, audio: audio, video: video)
        experiences.append(newExperience)
        experience = newExperience
    }
}
