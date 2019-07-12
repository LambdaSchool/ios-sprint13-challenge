//
//  ExperienceController.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import CoreLocation

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(title: String, image: UIImage, location: CLLocationCoordinate2D) {
        let newExperience = Experience(image: image, title: title, location: location)
        
        experiences.append(newExperience)
    }
    
    //save an experience
    //append to experiences
    
}
