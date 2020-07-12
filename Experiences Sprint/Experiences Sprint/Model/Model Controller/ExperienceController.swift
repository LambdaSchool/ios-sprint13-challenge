//
//  ExperienceController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperienceController {
    var experiences: [Experience] = []
    var experience: Experience?
    
    func createExperience(title: String,
                          image: UIImage?,
                          audio: URL?,
                          coordinate: CLLocationCoordinate2D) {
        
        var newExperience = Experience(title: title, image: image, audio: audio, coordinate: coordinate)
        experiences.append(newExperience)
        experience = newExperience
    }
}
