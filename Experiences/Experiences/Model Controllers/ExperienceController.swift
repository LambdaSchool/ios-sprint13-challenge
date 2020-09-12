//
//  ExperienceController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/12/20.
//

import UIKit
import MapKit

class ExperienceController {
    
    static let shared = ExperienceController()
    
    var experiences: [MKAnnotation] = []
    
    func addExperience(_ newExperience: Experience) {
        experiences.append(newExperience)
    }
    
}
