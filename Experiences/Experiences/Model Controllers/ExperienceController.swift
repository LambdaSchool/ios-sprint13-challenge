//
//  ExperienceController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/15/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    var experience: Experience?
    var experiences: [Experience] = []
    
    func createExperience(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        let newExperience = Experience(coordinate: coordinate, title: title, image: image, audio: audio, video: video)
        experiences.append(newExperience)
        experience = newExperience
    }
    
    
}
