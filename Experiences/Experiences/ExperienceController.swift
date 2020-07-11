//
//  ExperienceController.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
     
    var experiences: [Experience] = []
    var experience: Experience?
    
    func createNewExperience(title: String, image: UIImage?, audio: URL?, coordinate: CLLocationCoordinate2D) {
        
        var newExp = Experience(expTitle: title, image: image, audio: audio, coordinate: coordinate)
        experiences.append(newExp)
        experience = newExp
    }
}
